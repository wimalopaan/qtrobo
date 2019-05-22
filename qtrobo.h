#pragma once
#include <QObject>
#include <map>
#include <memory>

#include "connection.h"

class QtRobo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(Connection* connection READ connection NOTIFY connectionChanged)
    Q_PROPERTY(ConnectionType::ConnectionType connectionType MEMBER mConnectionType NOTIFY connectionChanged)

public:
    explicit QtRobo(QObject *parent = nullptr);
    ~QtRobo();

    Connection * connection();

signals:
    void connectionChanged();

public slots:

private:
    std::map<ConnectionType::ConnectionType, std::unique_ptr<Connection>> mConnections;
    ConnectionType::ConnectionType mConnectionType = ConnectionType::ConnectionType::Serial;
};

