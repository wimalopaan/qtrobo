#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QFile>
#include <QJsonObject>
#include <QDebug>
#include <algorithm>
#include "util.h"
#include "mobiledata.h"
#include "mobileconnection.h"
#include "debugmessagelist.h"


#ifdef Q_OS_ANDROID
    #include <QtAndroidExtras>
#endif



extern DebugMessageList debugMessageList;



SerialConnection::SerialConnection(QObject *parent)
    : Connection(parent)
{
    mPreferences[SerialConnection::PREFERENCE_BAUDRATE] = static_cast<int>(SerialConnection::DEFAULT_BAUDRATE);
    mPreferences[SerialConnection::PREFERENCE_STOPBIT] = static_cast<int>(SerialConnection::DEFAULT_STOPBITS);
    mPreferences[SerialConnection::PREFERENCE_PARITYBIT] = static_cast<int>(SerialConnection::DEFAULT_PARITYBITS);
    QObject::connect(&mSerialPort, SIGNAL(readyRead()), this, SLOT(onReadyRead()));


    if (Util::isMobileDevice()){
#ifdef Q_OS_ANDROID
        mSerialConnectionMobile = QAndroidJniObject("SerialConnector");
        mSerialConnectionMobile.setField<jobject>("context",QtAndroid::androidContext().object());
        mSerialConnectionMobile.callMethod<void>("initializeConnection");
        MobileData *data = new MobileData(mParser,mSerialConnectionMobile);
        MobileConnection *connection = new MobileConnection(mSerialConnectionMobile,*this);
        connection->start();
        data->start();
        QObject::connect(data,&MobileData::dataToRead, this, &SerialConnection::onReadyRead);
        QObject::connect(this,&SerialConnection::connectedFromJava, this, &SerialConnection::startHeartbeat);


#endif

    }



}

SerialConnection::SerialConnection(const SerialConnection &other)
    : SerialConnection(other.parent())
{}

SerialConnection::SerialConnection(SerialConnection &&other)
    : SerialConnection(other.parent())
{}



bool SerialConnection::isConnected() const{

    if (Util::isMobileDevice()){
#ifdef Q_OS_ANDROID

        jboolean j = mSerialConnectionMobile.callMethod<jboolean>("isConnected");
        return j == JNI_TRUE;
#endif
    }else{
      return mSerialPort.isOpen();
    }
}

void SerialConnection::writeImpl(const QString &eventName){
    const char* dataBytes = eventName.toStdString().c_str();

    if(mParser.eventEnd() == '\0'){
        if (Util::isMobileDevice()){
#ifdef Q_OS_ANDROID
            int arrayLength = strlen(dataBytes) + 1;
            writeDataMobile(arrayLength,dataBytes);
#endif
        }else{
            mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
        }
    }else{
        if (Util::isMobileDevice()){
#ifdef Q_OS_ANDROID
            int arrayLength = strlen(dataBytes);
            writeDataMobile(arrayLength,dataBytes);
#endif
        }else{
            mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
        }
    }
}

void SerialConnection::writeDataMobile(const int arrayLength, const char* dataBytes){
#ifdef Q_OS_ANDROID
    QAndroidJniEnvironment env;
    jbyteArray myJByteArray = env->NewByteArray((jsize) arrayLength);
    env->SetByteArrayRegion(myJByteArray, 0, arrayLength, (jbyte*)dataBytes);
    mSerialConnectionMobile.callMethod<void>("sendData", "([B)V", myJByteArray);
#endif
}

void SerialConnection::connectImpl(){


        if (Util::isMobileDevice()){
#ifdef Q_OS_ANDROID
            mSerialConnectionMobile.callMethod<void>("setBaudrate","(I)V",static_cast<QSerialPort::BaudRate>(mPreferences[SerialConnection::PREFERENCE_BAUDRATE].toInt()));
            mSerialConnectionMobile.callMethod<void>("setStopbits","(I)V",static_cast<QSerialPort::StopBits>(mPreferences[SerialConnection::PREFERENCE_STOPBIT].toInt()));
            mSerialConnectionMobile.callMethod<void>("setParity","(I)V",static_cast<QSerialPort::Parity>(mPreferences[SerialConnection::PREFERENCE_PARITYBIT].toInt()));
            mSerialConnectionMobile.callMethod<void>("requestPermissionAndConnect");
#endif
        }else{
            if(isConnected()){
                mSerialPort.close();
            }

            mSerialPort.setBaudRate(static_cast<QSerialPort::BaudRate>(mPreferences[SerialConnection::PREFERENCE_BAUDRATE].toInt()));
            mSerialPort.setStopBits(static_cast<QSerialPort::StopBits>(mPreferences[SerialConnection::PREFERENCE_STOPBIT].toInt()));
            mSerialPort.setParity(static_cast<QSerialPort::Parity>(mPreferences[SerialConnection::PREFERENCE_PARITYBIT].toInt()));
            mSerialPort.setPortName(mPreferences[SerialConnection::PREFERENCE_INTERFACE_NAME].toString());

            qDebug() << "Parity:" << mSerialPort.parity() << "\nBaudrate:" << mSerialPort.baudRate() << "\nStopbits:" << mSerialPort.stopBits() << "\nName:" << mSerialPort.portName();
            mSerialPort.open(QIODevice::ReadWrite);

            if(mSerialPort.isOpen())
                startHeartbeat();

        }
}

void SerialConnection::startHeartbeat(){
    if (mHeartbeatEnabled){
        QFile file("/storage/emulated/0/heartbeat.txt");
        file.open(QIODevice::WriteOnly | QIODevice::Text);
        QTextStream out(&file);
        out << "I am in startHeartbeat";
        file.close();
        mHeartbeat.start(static_cast<int>(mHeartbeatTimeout));
    }
}

void SerialConnection::disconnectImpl(){
    if (Util::isMobileDevice()){
#ifdef Q_OS_ANDROID

       if(isConnected())
            mSerialConnectionMobile.callMethod<void>("disconnect");
#endif
    }else{
        if(isConnected())
            mSerialPort.close();
    }
}

QStringList SerialConnection::serialInterfaces(){
    QSerialPortInfo serialPortInfo;
    QStringList portNames;

    for(auto info : serialPortInfo.availablePorts()){
        portNames << info.portName();

    }
    if(Util::isMobileDevice()){
#ifdef Q_OS_ANDROID
        portNames << "USB OTG";
#endif
    }

    return portNames;
}

QByteArray SerialConnection::read(){

    if (Util::isMobileDevice()){

#ifdef Q_OS_ANDROID

        QAndroidJniObject o = mSerialConnectionMobile.callObjectMethod<jbyteArray>("read");
        jbyteArray a = o.object<jbyteArray>();
        QAndroidJniEnvironment env;
        QByteArray resultArray;
        jsize len = env->GetArrayLength(a);
        resultArray.resize(len);
        env->GetByteArrayRegion(a, 0, len, reinterpret_cast<jbyte*>(resultArray.data()));
        return resultArray;
#endif

    }else{
      return mSerialPort.readAll();
    }

}

void SerialConnection::parseDebug(DebugInfoDirection::DebugInfoDirection direction, const QByteArray &data){
    QString result;

//    for(char byte : data){
//        switch(byte){
//            case '\n':
//                result.append("\\n");
//                break;
//            case '\r':
//                result.append("\\r");
//                break;
//            case '\0':
//                result.append("\\0");
//                break;
//            default:
//                result.append(byte);
//        }
//    }


    for (char byte: data){
        mDebug.append(byte);
        if (byte == '\n'){
           debugMessageList.appendItem(mDebug);
           mDebug = "";
        }
    }




}

QJsonObject SerialConnection::serialize(){
    QJsonObject result;

    result.insert(SerialConnection::PREFERENCE_INTERFACE_NAME, mPreferences[SerialConnection::PREFERENCE_INTERFACE_NAME].toString());
    result.insert(SerialConnection::PREFERENCE_BAUDRATE, mPreferences[SerialConnection::PREFERENCE_BAUDRATE].toInt());
    result.insert(SerialConnection::PREFERENCE_STOPBIT, mPreferences[SerialConnection::PREFERENCE_STOPBIT].toInt());
    result.insert(SerialConnection::PREFERENCE_PARITYBIT, mPreferences[SerialConnection::PREFERENCE_PARITYBIT].toInt());

    return result;
}

void SerialConnection::deserialize(const QJsonObject &data){

    if(!data.value(SerialConnection::PREFERENCE_INTERFACE_NAME).isNull()){
        mPreferences[SerialConnection::PREFERENCE_INTERFACE_NAME] = data.value(SerialConnection::PREFERENCE_INTERFACE_NAME).toString();
    }

    if(!data.value(SerialConnection::PREFERENCE_BAUDRATE).isNull()){
        mPreferences[SerialConnection::PREFERENCE_BAUDRATE] = data.value(SerialConnection::PREFERENCE_BAUDRATE).toInt();
    }

    if(!data.value(SerialConnection::PREFERENCE_STOPBIT).isNull()){
        mPreferences[SerialConnection::PREFERENCE_STOPBIT] = data.value(SerialConnection::PREFERENCE_STOPBIT).toInt();
    }

    if(!data.value(SerialConnection::PREFERENCE_PARITYBIT).isNull()){
        mPreferences[SerialConnection::PREFERENCE_PARITYBIT] = data.value(SerialConnection::PREFERENCE_PARITYBIT).toInt();
    }

    emit preferencesChanged(mPreferences);
}
