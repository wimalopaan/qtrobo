#pragma once
#include <QObject>
#include <QString>
#include <vector>
#include <QStringList>
#include <QSerialPort>
#include <QVariantList>

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

signals:
    void dataChanged(const QString &eventName, const QString &data);
    void connectionStateChanged(bool connectionState);
    void baudrateChanged(qint32 baudrate);
    void stopbitChanged(QSerialPort::StopBits stopbit);
    void paritybitChanged(QSerialPort::Parity parity);

public slots:
    void onReadyRead();

private:
    QSerialPort mSerialPort;
    QString mEventName;
    QString mData;

    static const char EVENT_VALUE_DIVIDER = ':';
};
