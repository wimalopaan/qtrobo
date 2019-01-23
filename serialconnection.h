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
    Q_PROPERTY(QString data MEMBER mData READ data NOTIFY onDataChanged)

public:
    SerialConnection(QObject *parent = nullptr);

    Q_INVOKABLE QStringList serialInterfaces() const;
    Q_INVOKABLE void connectToSerial(const QString &name);
    Q_INVOKABLE void disconnectFromSerial();
    Q_INVOKABLE void writeToSerial(const QString &data);
    Q_INVOKABLE bool isConnected();
    Q_INVOKABLE QVariantList jsonData();

    const QString& data() const;

signals:
    void onDataChanged(const QString &data);

public slots:
    void onReadyRead();

private:
    QSerialPort mSerialPort;
    QString mData;
};
