#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <QStringList>
#include <QSerialPort>
#include <QByteArray>
#include <QVariantList>
#include <QTimer>

#include "connection.h"
#include "messageparser.h"

class SerialConnection: public Connection
{

    Q_OBJECT
    //Q_PROPERTY(QString debug MEMBER mDebug NOTIFY debugChanged)

public:
    SerialConnection(QObject *parent = nullptr);

    bool isConnected() const override;

    QByteArray read() override;

    void writeImpl(const QString &eventName) override;

    void connect(const QVariantMap &preferences) override;
    void disconnect() override;

    Q_INVOKABLE QStringList serialInterfaces();
    /*Q_INVOKABLE void connectToSerial(const QString &name);
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

    void parseDebug(const QString& tag, const QByteArray& data);*/

signals:
    /*void dataChanged(const QString &eventName, const QString &data);
    void connectionStateChanged(bool connectionState);
    void baudrateChanged(qint32 baudrate);
    void stopbitChanged(QSerialPort::StopBits stopbit);
    void paritybitChanged(QSerialPort::Parity parity);
    void eventValueDividerChanged(char eventValueDivider);
    void eventEndChanged(char eventEnd);
    void eventStartChanged(char eventStart);

    void debugChanged(const QString& debug);
    */
public slots:
    /*void onReadyRead();
    void onParsedValueReady(MessageParser::Event event);
    void onHeartbeatTriggered();
    */

private:
    QSerialPort mSerialPort;
    /*QString mEventName;
    QString mData;
    QTimer mHeartbeat;
    MessageParser mParser;
    MessageParser::Event mEvent;

    QString mDebug;

    static const char DEFAULT_EVENT_START = '$';
    static const char DEFAULT_EVENT_VALUE_DIVIDER = ':';
    static const char DEFAULT_EVENT_END = '\n';
    */
};
