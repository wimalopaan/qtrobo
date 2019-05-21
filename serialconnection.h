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

public:
    SerialConnection(QObject *parent = nullptr);

    bool isConnected() const override;

    QByteArray read() override;

    void writeImpl(const QString &eventName) override;

    void connectImpl() override;
    void disconnectImpl() override;

    void parseDebug(const QString &tag, const QByteArray &data) override;

    Q_INVOKABLE QStringList serialInterfaces();

signals:

public slots:

private:
    QSerialPort mSerialPort;
};
