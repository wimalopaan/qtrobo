#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <QStringList>
#include <QSerialPort>

class SerialConnection: public QObject
{
    Q_OBJECT
public:
    SerialConnection(QObject *parent = nullptr);

    Q_INVOKABLE QStringList serialInterfaces() const;
    Q_INVOKABLE void connectToSerial(const QString &name);
    Q_INVOKABLE void disconnectFromSerial();
    Q_INVOKABLE void writeToSerial(const QString &data);
    Q_INVOKABLE QString readFromSerial();
    Q_INVOKABLE bool isConnected();

private:
    QSerialPort mSerialPort;
};
