#include "qtrobo.h"
#include "pipeconnection.h"
#include "serialconnection.h"

QtRobo::QtRobo(QObject *parent) : QObject(parent)
{
    mConnections[ConnectionType::ConnectionType::Serial] = std::make_unique<SerialConnection>(this);
    mConnections[ConnectionType::ConnectionType::Pipe] = std::make_unique<PipeConnection>(this);    
}

QtRobo::~QtRobo(){

}

Connection * QtRobo::connection(){
    return mConnections[mConnectionType].get();
}
