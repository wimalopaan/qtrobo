#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>


SerialConnection::SerialConnection(QObject *parent) :
    Connection(parent)
{
    mSerialPort.setBaudRate(9600);
    mSerialPort.setStopBits(QSerialPort::TwoStop);

    QObject::connect(&mSerialPort, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
}

bool SerialConnection::isConnected() const{
    return mSerialPort.isOpen();
}

void SerialConnection::writeImpl(const QString &eventName){
    const char* dataBytes = eventName.toStdString().c_str();

    //parseDebug("Out", QByteArray{dataBytes});

    if(mParser.eventEnd() == '\0')
        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
    else
        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
}

void SerialConnection::connect(const QVariantMap &preferences){

    if(!preferences["serial_interface"].isNull()){

        QString serialInterface = preferences["serial_interface"].toString();

        if(isConnected()){
            mSerialPort.close();
        }

        mSerialPort.setPortName(serialInterface);
        mSerialPort.open(QIODevice::ReadWrite);

        if(mSerialPort.isOpen() && mHeartbeatEnabled)
            mHeartbeat.start(mHeartbeatTimeout);

        emit connectionStateChanged(isConnected());
    }
}

void SerialConnection::disconnect(){
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

/*QStringList SerialConnection::serialInterfaces() const{
    QSerialPortInfo serialPortInfo;
    QStringList portNames;

    for(auto info : serialPortInfo.availablePorts()){
        portNames << info.portName();
    }

    return portNames;
}

void SerialConnection::connectToSerial(const QString &name){
    if(mSerialPort.isOpen()){
        disconnectFromSerial();
    }

    mSerialPort.setPortName(name);
    mSerialPort.open(QIODevice::ReadWrite);

    if(mSerialPort.isOpen() && mHeartbeatEnabled)
        mHeartbeat.start(mHeartbeatTimeout);

    emit connectionStateChanged(isConnected());
}

void SerialConnection::disconnectFromSerial(){
    if(mSerialPort.isOpen())
        mSerialPort.close();

    if(mHeartbeat.isActive())
        mHeartbeat.stop();

    emit connectionStateChanged(isConnected());
}

void SerialConnection::writeToSerial(const QString &eventName){

    if(mSerialPort.isOpen() && !eventName.isEmpty()){
        QString request;
        request += mParser.eventStart();
        request += eventName;
        request += mParser.eventEnd();
        const char* dataBytes = request.toStdString().c_str();

        parseDebug("Out", QByteArray{dataBytes});

        if(mParser.eventEnd() == '\0')
            mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
        else
            mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
    }
}

void SerialConnection::writeToSerial(const QString &eventName, const QVariant &value){
    QString request;
    request += eventName;
    request += mParser.eventValueDivider();
    request += value.toString();

    writeToSerial(request);
}

void SerialConnection::onReadyRead(){
    if(mSerialPort.isOpen()){

        QByteArray dataBuffer = mSerialPort.readAll();
        parseDebug("In", dataBuffer);
        mParser.parseData(dataBuffer);
    }
}

void SerialConnection::onParsedValueReady(MessageParser::Event event){
    if(mHeartbeatEnabled && event.eventName.contains(mHeartbeatResponse)){
        mHeartbeatStatus = true;
        return;
    }

    emit dataChanged(event.eventName, event.value);
}

void SerialConnection::onHeartbeatTriggered(){
    emit heartbeatTriggered(mHeartbeatStatus);
    mHeartbeatStatus = false;

    writeToSerial(mHeartbeatRequest);
}

const QString& SerialConnection::data() const{
    return mEvent.eventName;
}

const QString& SerialConnection::eventName() const{
    return mEvent.value;
}

QString SerialConnection::portName() const{
    return mSerialPort.portName();
}

bool SerialConnection::isConnected() const{
    return mSerialPort.isOpen();
}

qint32 SerialConnection::baudrate() const{
    return mSerialPort.baudRate();
}

void SerialConnection::baudrate(qint32 baudrate){
    mSerialPort.setBaudRate(baudrate);
}

QSerialPort::StopBits SerialConnection::stopbit() const{
    return mSerialPort.stopBits();
}

void SerialConnection::stopbit(QSerialPort::StopBits stopbit){
    mSerialPort.setStopBits(stopbit);
}

QSerialPort::Parity SerialConnection::paritybit() const{
    return mSerialPort.parity();
}

void SerialConnection::paritybit(QSerialPort::Parity paritybit){
    mSerialPort.setParity(paritybit);
}

char SerialConnection::eventValueDivider() const{
    return mParser.eventValueDivider();
}

void SerialConnection::eventValueDivider(char eventValueDivider){
    mParser.eventValueDivider(eventValueDivider);
}

char SerialConnection::eventEnd() const{
    return mParser.eventEnd();
}

void SerialConnection::eventEnd(char eventEnd){
    mParser.eventEnd(eventEnd);
}

char SerialConnection::eventStart() const{
    return mParser.eventStart();
}

void SerialConnection::eventStart(char eventStart){
    mParser.eventStart(eventStart);
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

*/
