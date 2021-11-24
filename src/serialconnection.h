#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <QStringList>
#include <QSerialPort>
#include <QByteArray>
#include <QVariantList>
#include <QTimer>

#ifdef Q_OS_ANDROID
    #include <QtAndroidExtras>
#endif

#include "connection.h"
#include "messageparser.h"

class SerialConnection: public Connection
{

    Q_OBJECT

public:
    SerialConnection(QObject *parent = nullptr);
    SerialConnection(const SerialConnection &other);
    SerialConnection(SerialConnection &&other);

    bool isConnected() const override;

    QByteArray read() override;

    void writeImpl(const QString &eventName) override;

    void startHeartbeat();

    void connectImpl() override;
    void disconnectImpl() override;
    void writeDataMobile(const int arrayLength, const char* dataBytes);

    void parseDebug(DebugInfoDirection::DebugInfoDirection direction, const QByteArray &data) override;

    Q_INVOKABLE QStringList serialInterfaces();

    QJsonObject serialize() override;
    void deserialize(const QJsonObject &data) override;

signals:
    void startListening();
    void connectedFromJava();

public slots:

private:
    QSerialPort mSerialPort;
#ifdef Q_OS_ANDROID
    QAndroidJniObject mSerialConnectionMobile;
#endif


    static const QSerialPort::BaudRate DEFAULT_BAUDRATE = QSerialPort::BaudRate::Baud9600;
    static const QSerialPort::StopBits DEFAULT_STOPBITS = QSerialPort::StopBits::OneStop;
    static const QSerialPort::Parity DEFAULT_PARITYBITS = QSerialPort::Parity::NoParity;

    static inline const QString PREFERENCE_BAUDRATE{"serialBaudrate"};
    static inline const QString PREFERENCE_STOPBIT{"serialStopbit"};
    static inline const QString PREFERENCE_PARITYBIT{"serialParitybit"};
    static inline const QString PREFERENCE_INTERFACE_NAME{"serialInterfaceName"};
};
