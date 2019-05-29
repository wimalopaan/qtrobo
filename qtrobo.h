#pragma once
#include <QObject>
#include <QJsonObject>
#include <map>
#include <memory>

#include "persistance.h"
#include "connection.h"

class QtRobo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(Connection* connection READ connection NOTIFY connectionChanged)
    Q_PROPERTY(Persistance* persistance READ persistance NOTIFY persistanceChanged)
    Q_PROPERTY(ConnectionType::ConnectionType connectionType MEMBER mConnectionType NOTIFY connectionChanged)

public:
    explicit QtRobo(QObject *parent = nullptr);
    ~QtRobo();

    Connection * connection();
    Persistance * persistance();

signals:
    void connectionChanged();
    void persistanceChanged();

public slots:
    void onPersisting(QJsonObject &data);
    void onRestoring(QJsonObject data);

private:
    std::map<ConnectionType::ConnectionType, std::unique_ptr<Connection>> mConnections;
    ConnectionType::ConnectionType mConnectionType = ConnectionType::ConnectionType::Serial;
    Persistance mPersistance;
};

