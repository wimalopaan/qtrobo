#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>
#include <iostream>

const char SerialConnection::DEFAULT_EVENT_START;
const char SerialConnection::DEFAULT_EVENT_VALUE_DIVIDER;
const char SerialConnection::DEFAULT_EVENT_END;

SerialConnection::SerialConnection(QObject *parent) :
    QObject(parent),
    mParser(this)
{
    connect(&mSerialPort, SIGNAL(readyRead()), SLOT(onReadyRead()));
    connect(&mParser, &MessageParser::messageParsed, this, &SerialConnection::onParsedValueReady);

    mSerialPort.setBaudRate(9600);
    mSerialPort.setStopBits(QSerialPort::TwoStop);

    mParser.eventStart(DEFAULT_EVENT_START);
    mParser.eventValueDivider(DEFAULT_EVENT_VALUE_DIVIDER);
    mParser.eventEnd(DEFAULT_EVENT_END);
}

QStringList SerialConnection::serialInterfaces() const{
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

    emit connectionStateChanged(isConnected());
}

void SerialConnection::disconnectFromSerial(){
    if(mSerialPort.isOpen())
        mSerialPort.close();
    emit connectionStateChanged(isConnected());
}

void SerialConnection::writeToSerial(const QString &eventName){

    if(mSerialPort.isOpen() && !eventName.isEmpty()){
        qDebug() << "Writing: " << eventName;
        const char* dataBytes = eventName.toStdString().c_str();

        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes) + 1));
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

        mParser.parseData(dataBuffer);

    }
}

void SerialConnection::onParsedValueReady(MessageParser::Event event){
    std::cout << event << std::endl;
    emit dataChanged(event.eventName, event.value);
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

bool SerialConnection::isConnected(){
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
