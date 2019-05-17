#include "connection.h"
#include <algorithm>

Connection::Connection(QObject *parent) : QObject(parent)
{
    QObject::connect(&mParser, &MessageParser::messageParsed, this, &Connection::onParsedDataReady);
    QObject::connect(&mHeartbeat, SIGNAL(timeout()), this, SLOT(onHeartbeatTriggered()));
    mParser.eventStart('$');
    mParser.eventValueDivider(':');
}

Connection::Connection(const Connection &connection) : Connection(connection.parent())
{
    mEvent = connection.mEvent;
}

Connection::~Connection(){}

void Connection::write(const QString &eventName){
    if(isConnected() && !eventName.isEmpty()){
        QString request;
        request += mParser.eventStart();
        request += eventName;
        request += mParser.eventEnd();

        writeImpl(request);
    }
}

void Connection::write(const QString &eventName, const QVariant &data){
    QString request;
    request += eventName;
    request += mParser.eventValueDivider();
    request += data.toString();

    write(request);
}

const QString& Connection::eventName() const{
    return mEvent.eventName;
}

const QString& Connection::data() const{
    return mEvent.value;
}

MessageParser* Connection::messageParser(){
    return &mParser;
}

Connection& Connection::operator=(Connection &other){
    swap(*this, other);

    return *this;
}

void Connection::onReadyRead(){
    if(isConnected()){
        QByteArray dataBuffer = read();
        //parseDebug("In", dataBuffer);
        mParser.parseData(dataBuffer);
    }
}

void Connection::onParsedDataReady(const MessageParser::Event &event){
    if(mHeartbeatEnabled && event.eventName.contains(mHeartbeatResponse)){
        mHeartbeatStatus = true;
        return;
    }

    emit dataChanged(event.eventName, event.value);
}

void Connection::onHeartbeatTriggered(){
    emit heartbeatTriggered(mHeartbeatStatus);
    mHeartbeatStatus = false;

    write(mHeartbeatRequest);
}

void swap(Connection &lhs, Connection &rhs){
    using std::swap;
    swap(lhs.mEvent, rhs.mEvent);
}
