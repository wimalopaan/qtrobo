#include "qtrobo.h"
#include "serialconnection.h"
#include "localsocketconnection.h"

QtRobo::QtRobo(QObject *parent) : QObject(parent)
{
    mConnections[ConnectionType::ConnectionType::Serial] = std::make_unique<SerialConnection>(this);
    mConnections[ConnectionType::ConnectionType::Socket] = std::make_unique<LocalSocketConnection>(this);

    QObject::connect(&mPersistance, &Persistance::serializeConnection, this, &QtRobo::onPersisting);
    QObject::connect(&mPersistance, &Persistance::deserializeConnection, this, &QtRobo::onRestoring);
}

QtRobo::~QtRobo(){

}

Connection * QtRobo::connection(){
    return mConnections[mConnectionType].get();
}

Persistance * QtRobo::persistance(){
    return &mPersistance;
}

void QtRobo::onPersisting(QJsonObject &data){
    data.insert("serialport", mConnections[ConnectionType::ConnectionType::Serial]->serialize());
    data.insert("localsocket", mConnections[ConnectionType::ConnectionType::Socket]->serialize());
}

void QtRobo::onRestoring(QJsonObject data){
    auto serialPortObject = data.find("serialport").value();
    auto localSocketObject = data.find("localsocket").value();

    if(!serialPortObject.isNull() && serialPortObject.isObject())
        mConnections[ConnectionType::ConnectionType::Serial]->deserialize(serialPortObject.toObject());

    if(!localSocketObject.isNull() && localSocketObject.isObject())
        mConnections[ConnectionType::ConnectionType::Socket]->deserialize(localSocketObject.toObject());
}
