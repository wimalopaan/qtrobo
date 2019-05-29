#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QFile>
#include <QJsonObject>
#include <QDebug>


SerialConnection::SerialConnection(QObject *parent) :
    Connection(parent)
{
    mPreferences[SerialConnection::PREFERENCE_BAUDRATE] = static_cast<int>(SerialConnection::DEFAULT_BAUDRATE);
    mPreferences[SerialConnection::PREFERENCE_STOPBIT] = static_cast<int>(SerialConnection::DEFAULT_STOPBITS);
    mPreferences[SerialConnection::PREFERENCE_PARITYBIT] = static_cast<int>(SerialConnection::DEFAULT_PARITYBITS);

    QObject::connect(&mSerialPort, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
}

bool SerialConnection::isConnected() const{
    return mSerialPort.isOpen();
}

void SerialConnection::writeImpl(const QString &eventName){
    const char* dataBytes = eventName.toStdString().c_str();
    if(mParser.eventEnd() == '\0')
        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
    else
        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
}

void SerialConnection::connectImpl(){

        if(isConnected()){
            mSerialPort.close();
        }

        mSerialPort.setBaudRate(static_cast<QSerialPort::BaudRate>(mPreferences[SerialConnection::PREFERENCE_BAUDRATE].toInt()));
        mSerialPort.setStopBits(static_cast<QSerialPort::StopBits>(mPreferences[SerialConnection::PREFERENCE_STOPBIT].toInt()));
        mSerialPort.setParity(static_cast<QSerialPort::Parity>(mPreferences[SerialConnection::PREFERENCE_PARITYBIT].toInt()));

        qDebug() << "Raw Input: " << mPreferences[SerialConnection::PREFERENCE_STOPBIT];

        mSerialPort.setPortName(mPreferences[SerialConnection::PREFERENCE_INTERFACE_NAME].toString());

        qDebug() << "Parity:" << mSerialPort.parity() << "\nBaudrate:" << mSerialPort.baudRate() << "\nStopbits:" << mSerialPort.stopBits() << "\nName:" << mSerialPort.portName();
        mSerialPort.open(QIODevice::ReadWrite);

        if(mSerialPort.isOpen() && mHeartbeatEnabled)
            mHeartbeat.start(static_cast<int>(mHeartbeatTimeout));

        emit connectionStateChanged(isConnected());

}

void SerialConnection::disconnectImpl(){
    if(isConnected())
        mSerialPort.close();
    emit connectionStateChanged(isConnected());
}

QStringList SerialConnection::serialInterfaces(){
    QSerialPortInfo serialPortInfo;
    QStringList portNames;

    for(auto info : serialPortInfo.availablePorts()){
        portNames << info.portName();
    }

    return portNames;
}

QByteArray SerialConnection::read(){
    return mSerialPort.readAll();
}

void SerialConnection::parseDebug(const QString& tag, const QByteArray &data){
    QString result = tag;
    result.append("\u27A1");

    for(char byte : data){
        switch(byte){
            case '\n':
                result.append("\\n");
                break;
            case '\r':
                result.append("\\r");
                break;
            case '\0':
                result.append("\\0");
                break;
            default:
                result.append(byte);
        }
    }

    emit debugChanged(result);
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
