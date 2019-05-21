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
    if(mParser.eventEnd() == '\0')
        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
    else
        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
}

void SerialConnection::connectImpl(){

        if(isConnected()){
            mSerialPort.close();
        }


        mSerialPort.setParity(static_cast<QSerialPort::Parity>(mPreferences["paritybit"].toInt()));
        mSerialPort.setBaudRate(static_cast<QSerialPort::BaudRate>(mPreferences["baudrate"].toInt()));
        mSerialPort.setStopBits(static_cast<QSerialPort::StopBits>(mPreferences["stopbit"].toInt()));
        mSerialPort.setPortName(mPreferences["interfaceName"].toString());

        qDebug() << "Parity:" << mSerialPort.parity() << "\nBaudrate:" << mSerialPort.baudRate() << "\nStopbits:" << mSerialPort.stopBits() << "\nName:" << mSerialPort.portName();
        mSerialPort.open(QIODevice::ReadWrite);

        if(mSerialPort.isOpen() && mHeartbeatEnabled)
            mHeartbeat.start(mHeartbeatTimeout);

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

