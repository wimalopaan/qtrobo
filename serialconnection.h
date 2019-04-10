#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <QStringList>
#include <QSerialPort>
#include <QVariantList>
#include <QTimer>

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
    Q_PROPERTY(char eventEnd READ eventEnd WRITE eventEnd NOTIFY eventEndChanged)
    Q_PROPERTY(char eventStart READ eventStart WRITE eventStart NOTIFY eventStartChanged)
    Q_PROPERTY(QString heartbeatRequest MEMBER mHeartbeatRequest NOTIFY heartbeatRequestChanged)
    Q_PROPERTY(QString heartbeatResponse MEMBER mHeartbeatResponse NOTIFY heartbeatResponseChanged)
    Q_PROPERTY(int heartbeatTimeout MEMBER mHeartbeatTimeout NOTIFY heartbeatTimeoutChanged)
    Q_PROPERTY(bool heartbeatStatus MEMBER mHeartbeatStatus NOTIFY heartbeatTriggered)
    Q_PROPERTY(bool heartbeatEnabled MEMBER mHeartbeatEnabled NOTIFY heartbeatEnabledChanged)
    Q_PROPERTY(QByteArray debug MEMBER mDebug NOTIFY debugChanged)

public:
    SerialConnection(QObject *parent = nullptr);

    Q_INVOKABLE QStringList serialInterfaces() const;
    Q_INVOKABLE void connectToSerial(const QString &name);
    Q_INVOKABLE void disconnectFromSerial();
    Q_INVOKABLE void writeToSerial(const QString &eventName);
    Q_INVOKABLE void writeToSerial(const QString &eventName, const QVariant &value);
    Q_INVOKABLE bool isConnected() const;

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
    void eventEndChanged(char eventEnd);
    void eventStartChanged(char eventStart);
    void heartbeatTriggered(bool heartbeatStatus);
    void heartbeatRequestChanged(const QString &heartbeatRequest);
    void heartbeatResponseChanged(const QString &heartbeatResponse);
    void heartbeatTimeoutChanged(int heartbeatTimeout);
    void heartbeatEnabledChanged(bool heartbeatEnabled);
    void debugChanged(const QByteArray& debug);

public slots:
    void onReadyRead();
    void onParsedValueReady(MessageParser::Event event);
    void onHeartbeatTriggered();

private:
    QSerialPort mSerialPort;
    QString mEventName;
    QString mData;
    QTimer mHeartbeat;
    MessageParser mParser;
    MessageParser::Event mEvent;
    QString mHeartbeatRequest;
    QString mHeartbeatResponse;
    int mHeartbeatTimeout;
    bool mHeartbeatStatus;
    bool mHeartbeatEnabled;
    QByteArray mDebug;

    static const char DEFAULT_EVENT_START = '$';
    static const char DEFAULT_EVENT_VALUE_DIVIDER = ':';
    static const char DEFAULT_EVENT_END = '\n';
};
