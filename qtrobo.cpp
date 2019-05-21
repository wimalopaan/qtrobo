#include "qtrobo.h"
#include "serialconnection.h"
#include "localsocketconnection.h"

QtRobo::QtRobo(QObject *parent) : QObject(parent)
{
    mConnections[ConnectionType::ConnectionType::Serial] = std::make_unique<SerialConnection>(this);
    mConnections[ConnectionType::ConnectionType::Socket] = std::make_unique<LocalSocketConnection>(this);
}

QtRobo::~QtRobo(){

}

Connection * QtRobo::connection(){
    return mConnections[mConnectionType].get();
}
