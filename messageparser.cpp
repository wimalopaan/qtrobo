#include "messageparser.h"
#include <QChar>
#include <algorithm>

MessageParser::MessageParser(QObject *parent)
    : QObject(parent), mCurrentState(State::START)
{}

MessageParser::MessageParser(const MessageParser &other)
    : QObject(other.parent()),
      mEventStart(other.mEventStart),
      mEventValueDivider(other.mEventValueDivider),
      mEventEnd(other.mEventEnd),
      mCurrentState(other.mCurrentState),
      mCurrentEvent(other.mCurrentEvent)

{}

MessageParser::MessageParser(MessageParser &&other)
    : QObject(other.parent())
{
    swap(other, *this);
}

char MessageParser::eventStart() const{
    return mEventStart;
}

void MessageParser::eventStart(char eventStart){
    mEventStart = eventStart;
}

char MessageParser::eventValueDivider() const{
    return mEventValueDivider;
}

void MessageParser::eventValueDivider(char eventValueDivider){
    mEventValueDivider = eventValueDivider;
}

char MessageParser::eventEnd() const{
    return mEventEnd;
}

void MessageParser::eventEnd(char eventEnd){
    mEventEnd = eventEnd;
}

void MessageParser::parseData(char byte){

    switch(mCurrentState){
    case State::START:
        if(byte == mEventStart){
            mCurrentState = State::EVENT;
            mCurrentEvent = Event{};
        }
        break;

    case State::EVENT:
        if(byte == mEventValueDivider)
            mCurrentState = State::VALUE;
        else if(byte == mEventEnd){
            mCurrentState = State::START;
            emit messageParsed(mCurrentEvent);
        }
        else if(QChar::isLetterOrNumber(static_cast<uint>(byte)))
            mCurrentEvent.eventName.append(byte);
        break;

    case State::VALUE:
        if(byte == mEventEnd){
            mCurrentState = State::START;
            emit messageParsed(mCurrentEvent);
        }
        else if(QChar::isLetterOrNumber(static_cast<uint>(byte)) || byte == '-')
            mCurrentEvent.value.append(byte);

        break;
    }
}

void MessageParser::parseData(const QByteArray& data){
    for(const char& byte : data){
        parseData(byte);
    }
}

MessageParser& MessageParser::operator=(const MessageParser &other){

    if(&other != this){
        MessageParser tmp{other};
        swap(tmp, *this);
    }
    return *this;
}

MessageParser& MessageParser::operator=(MessageParser &&other){

    if(&other != this)
        swap(other, *this);

    return *this;
}

std::ostream& operator<<(std::ostream& out, const MessageParser::Event& event){
    return out << "Event[event:" << event.eventName.toStdString() << ",value:" << event.value.toStdString() << "]";
}

QDebug operator<<(QDebug debug, const MessageParser::Event& event){
    QDebugStateSaver saver{debug};
    debug.nospace() << "Event[event:" << event.eventName << ",value:" << event.value << "]";
    return debug;
}

void swap(MessageParser &lhs, MessageParser &rhs){
    using std::swap;

    swap(lhs.mEventStart, rhs.mEventStart);
    swap(lhs.mEventValueDivider, rhs.mEventValueDivider);
    swap(lhs.mEventEnd, rhs.mEventEnd);
    swap(lhs.mCurrentState, rhs.mCurrentState);
    swap(lhs.mCurrentEvent, rhs.mCurrentEvent);
}
