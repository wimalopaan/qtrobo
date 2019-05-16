#include "pipeconnection.h"

PipeConnection::PipeConnection(QObject *parent) : Connection(parent)
{

}

void PipeConnection::write(const QString &eventName){

}

void PipeConnection::write(const QString &eventName, const QString &data){

}

void PipeConnection::connect(){

}

void PipeConnection::disconnect(){

}

bool PipeConnection::isConnected() const{

    return false;
}
