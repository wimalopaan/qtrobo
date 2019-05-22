#pragma once

#include "connection.h"
#include <QLocalSocket>

class LocalSocketConnection : public Connection
{
public:
    explicit LocalSocketConnection(QObject *parent = nullptr);

    QByteArray read() override;

    void writeImpl(const QString &eventName) override;

    void connectImpl() override;
    void disconnectImpl() override;

    bool isConnected() const override;

    void parseDebug(const QString &tag, const QByteArray &data) override;

private:
    QLocalSocket mLocalSocket;

    static inline const QString PREFERENCE_SOCKET_NAME{"socketName"};
};
