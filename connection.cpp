#include "connection.h"
#include <algorithm>

Connection::Connection(QObject *parent)
    : QObject(parent),
      mHeartbeatTimeout(DEFAULT_HEARTBEAT_TIMEOUT),
      mHeartbeatRequest(DEFAULT_HEARTBEAT_REQUEST),
      mHeartbeatResponse(DEFAULT_HEARTBEAT_RESPONSE),
      mHeartbeatEnabled(DEFAULT_HEARTBEAT_ENABLED)
{
    QObject::connect(&mParser, &MessageParser::messageParsed, this, &Connection::onParsedDataReady);
    QObject::connect(&mHeartbeat, SIGNAL(timeout()), this, SLOT(onHeartbeatTriggered()));

    mParser.eventStart(DEFAULT_EVENT_START);
    mParser.eventValueDivider(DEFAULT_EVENT_VALUE_DIVIDER);
    mParser.eventEnd(DEFAULT_EVENT_END);
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

        parseDebug("Out", request.toLocal8Bit());

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

void Connection::connect(){
    if(isConnected() && mHeartbeatEnabled)
        mHeartbeat.start(mHeartbeatTimeout);

    connectImpl();
}

void Connection::disconnect(){
    disconnectImpl();

    if(mHeartbeat.isActive())
        mHeartbeat.stop();
}

Connection& Connection::operator=(Connection &other){
    swap(*this, other);

    return *this;
}

void Connection::onReadyRead(){
    if(isConnected()){
        QByteArray dataBuffer = read();
        parseDebug("In", dataBuffer);
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
