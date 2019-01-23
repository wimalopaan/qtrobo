#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <iostream>
#include <string.h>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>

SerialConnection::SerialConnection(QObject *parent) :
    QObject(parent)
{
    connect(&mSerialPort, SIGNAL(readyRead()), SLOT(onReadyRead()));
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
    mSerialPort.setBaudRate(9600);
    mSerialPort.setStopBits(QSerialPort::TwoStop);
    mSerialPort.open(QIODevice::ReadWrite);
}

void SerialConnection::disconnectFromSerial(){
    std::cout << "Is Open: " << (mSerialPort.isOpen() ? "True" : "False") << std::endl;
    mSerialPort.close();

}

void SerialConnection::writeToSerial(const QString &data){

    if(mSerialPort.isOpen()){
        std::cout << "Writing: " << data.toStdString().c_str() << std::endl;
        const char* dataBytes = data.toStdString().c_str();

        mSerialPort.write(dataBytes, static_cast<qint64>(strlen(dataBytes) + 1));
    }
}

void SerialConnection::onReadyRead(){
    if(mSerialPort.isOpen()){
        QByteArray mDataBuffer;
        mDataBuffer.append(mSerialPort.readAll());

        mData = QString{mDataBuffer};
        if(mData.length() > 0){
            std::cout << "Reading:" << mData.toStdString() << std::endl;
            emit onDataChanged(mData);
        }
    }
}

const QString& SerialConnection::data() const{
    return mData;
}

bool SerialConnection::isConnected(){
    return mSerialPort.isOpen();
}


QVariantList SerialConnection::jsonData(){
    QFile file{"myfile.json"};
    file.open(QIODevice::ReadOnly);
    QString data = QString::fromUtf8(file.readAll());

    file.close();
    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8(), &err);

    qDebug() << QString{doc.toJson()};

    return QVariantList{};
}
