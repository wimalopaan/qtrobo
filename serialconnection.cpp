#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>

const char SerialConnection::EVENT_VALUE_DIVIDER;

SerialConnection::SerialConnection(QObject *parent) :
    QObject(parent)
{
    connect(&mSerialPort, SIGNAL(readyRead()), SLOT(onReadyRead()));

    mSerialPort.setBaudRate(9600);
    mSerialPort.setStopBits(QSerialPort::TwoStop);
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
    QString request{};
    request += eventName;
    request += EVENT_VALUE_DIVIDER;
    request += value.toString();

    writeToSerial(request);
}

void SerialConnection::onReadyRead(){
    if(mSerialPort.isOpen()){
        QByteArray mDataBuffer;
        mDataBuffer.append(mSerialPort.readAll());

        QString response{mDataBuffer};


        if(!response.isEmpty()){
            QStringList responseToken = response.split(EVENT_VALUE_DIVIDER);

            if(responseToken.length() > 1)
                emit dataChanged(responseToken[0], responseToken[1]);
            else
                emit dataChanged(QString{}, responseToken[0]);
        }
    }
}

const QString& SerialConnection::data() const{
    return mData;
}

const QString& SerialConnection::eventName() const{
    return mEventName;
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
