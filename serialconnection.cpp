#include "serialconnection.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <iostream>

SerialConnection::SerialConnection(QObject *parent) :
    QObject(parent)
{
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
    mSerialPort.open(QIODevice::ReadWrite);
}

void SerialConnection::disconnectFromSerial(){
    std::cout << "Is Open: " << (mSerialPort.isOpen() ? "True" : "False") << std::endl;
    mSerialPort.close();

}

void SerialConnection::writeToSerial(const QString &data){

    if(mSerialPort.isOpen()){
        std::cout << "Writing: " << data.toStdString().c_str() << std::endl;
        mSerialPort.write(data.toStdString().c_str());
    }
}

QString SerialConnection::readFromSerial(){
    if(mSerialPort.isOpen()){
        char buffer[128];

        mSerialPort.readLine(buffer, 128);
        QString response{buffer};
        if(response.length() > 0){
            std::cout << "Reading:" << response.toStdString() << std::endl;
            return response;
        }
    }

    return QString{};
}

bool SerialConnection::isConnected(){
    return mSerialPort.isOpen();
}
