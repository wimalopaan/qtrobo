#pragma once
#include <QObject>
#include <QByteArray>
#include <QDebug>
#include <iostream>

class MessageParser: public QObject
{
    Q_OBJECT
    Q_PROPERTY(char eventStart READ eventStart WRITE eventStart NOTIFY eventStartChanged)
    Q_PROPERTY(char eventValueDivider READ eventValueDivider WRITE eventValueDivider NOTIFY eventValueDividerChanged)
    Q_PROPERTY(char eventEnd READ eventEnd WRITE eventEnd NOTIFY eventEndChanged)

public:
    enum class State{
        START,
        EVENT,
        VALUE
    };

    struct Event{
        QString eventName;
        QString value;

    };

    explicit MessageParser(QObject *parent = nullptr);
    MessageParser(const MessageParser &other);
    MessageParser(MessageParser &&other);

    char eventStart() const;
    void eventStart(char eventStart);

    char eventValueDivider() const;
    void eventValueDivider(char eventValueDivider);

    char eventEnd() const;
    void eventEnd(char eventEnd);

    void parseData(char byte);
    void parseData(const QByteArray& data);

    MessageParser& operator=(const MessageParser &other);
    MessageParser& operator=(MessageParser &&other);

    friend std::ostream& operator<<(std::ostream& out, const Event& event);
    friend QDebug operator<<(QDebug debug, const Event& event);
    friend void swap(MessageParser &lhs, MessageParser &rhs);

signals:
    void messageParsed(Event event);
    void eventStartChanged(char eventStart);
    void eventValueDividerChanged(char eventValueDivider);
    void eventEndChanged(char eventEnd);

public slots:

private:
    //MessageParser(const MessageParser&);

    char mEventStart = '$';
    char mEventValueDivider;
    char mEventEnd;

    State mCurrentState;
    Event mCurrentEvent;
};

