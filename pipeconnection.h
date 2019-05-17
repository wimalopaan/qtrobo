#pragma once

#include <QObject>
#include <QFile>
#include <QByteArray>

#include "connection.h"

class PipeConnection : public Connection
{
public:
    explicit PipeConnection(QObject *parent = nullptr);

    QByteArray read() override;

    void writeImpl(const QString &eventName) override;

    void connect() override;
    void disconnect() override;

    bool isConnected() const override;

private:
    QFile mInputPipe;
    QFile mOutputPipe;
};
