#pragma once

#include <QObject>

#include "connection.h"

class PipeConnection : public Connection
{
public:
    explicit PipeConnection(QObject *parent = nullptr);

    void write(const QString &eventName) override;
    void write(const QString &eventName, const QString &data) override;

    void connect() override;
    void disconnect() override;

    bool isConnected() const override;
};
