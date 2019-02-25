#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <QStringList>
#include <QSerialPort>
#include <QVariantList>

#include "messageparser.h"

class SerialConnection: public QObject
{

    Q_OBJECT
    Q_PROPERTY(QString data READ data NOTIFY dataChanged)
    Q_PROPERTY(QString eventName READ eventName NOTIFY dataChanged)
    Q_PROPERTY(QString portName READ portName)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionStateChanged)
    Q_PROPERTY(qint32 baudrate READ baudrate WRITE baudrate NOTIFY baudrateChanged)
    Q_PROPERTY(QSerialPort::StopBits stopbit READ stopbit WRITE stopbit NOTIFY stopbitChanged)
    Q_PROPERTY(QSerialPort::Parity paritybit READ paritybit WRITE paritybit NOTIFY paritybitChanged)
    Q_PROPERTY(char eventValueDivider READ eventValueDivider WRITE eventValueDivider NOTIFY eventValueDividerChanged)
    Q_PROPERTY(char eventEOL READ eventEnd WRITE eventEnd NOTIFY eventEOLChanged)
    Q_PROPERTY(char eventStart READ eventStart WRITE eventStart NOTIFY eventStartChanged)

public:
    SerialConnection(QObject *parent = nullptr);

    Q_INVOKABLE QStringList serialInterfaces() const;
    Q_INVOKABLE void connectToSerial(const QString &name);
    Q_INVOKABLE void disconnectFromSerial();
    Q_INVOKABLE void writeToSerial(const QString &eventName);
    Q_INVOKABLE void writeToSerial(const QString &eventName, const QVariant &value);
    Q_INVOKABLE bool isConnected();

    const QString& data() const;

    const QString& eventName() const;

    QString portName() const;

    qint32 baudrate() const;
    void baudrate(qint32 baudrate);

    QSerialPort::StopBits stopbit() const;
    void stopbit(QSerialPort::StopBits stopbit);

    QSerialPort::Parity paritybit() const;
    void paritybit(QSerialPort::Parity paritybit);

    char eventValueDivider() const;
    void eventValueDivider(char eventValueDivider);

    char eventEnd() const;
    void eventEnd(char eventEnd);

    char eventStart() const;
    void eventStart(char eventStart);

signals:
    void dataChanged(const QString &eventName, const QString &data);
    void connectionStateChanged(bool connectionState);
    void baudrateChanged(qint32 baudrate);
    void stopbitChanged(QSerialPort::StopBits stopbit);
    void paritybitChanged(QSerialPort::Parity parity);
    void eventValueDividerChanged(char eventValueDivider);
    void eventEOLChanged(char eventEOL);
    void eventStartChanged(char eventStart);

public slots:
    void onReadyRead();
    void onParsedValueReady(MessageParser::Event event);

private:
    QSerialPort mSerialPort;
    QString mEventName;
    QString mData;

    MessageParser mParser;
    MessageParser::Event mEvent;

    static const char DEFAULT_EVENT_START = '$';
    static const char DEFAULT_EVENT_VALUE_DIVIDER = ':';
    static const char DEFAULT_EVENT_END = '\n';
};
