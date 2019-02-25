#include "messageparser.h"

MessageParser::MessageParser(QObject *parent) : QObject(parent), mCurrentState(State::START){}

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
        else
            mCurrentEvent.eventName.append(byte);
        break;

    case State::VALUE:
        if(byte == mEventEnd)
            mCurrentState = State::END;
        else
            mCurrentEvent.value.append(byte);
        break;

    case State::END:
        mCurrentState = State::START;
        emit messageParsed(mCurrentEvent);
        break;
    }
}

void MessageParser::parseData(const QByteArray& data){
    for(const char& byte : data){
        parseData(byte);
    }
}

std::ostream& operator<<(std::ostream& out, const MessageParser::Event& event){
    return out << "Event[event:" << event.eventName.toStdString() << ",value:" << event.value.toStdString() << "]";
}
