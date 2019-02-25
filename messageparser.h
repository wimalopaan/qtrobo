#pragma once
#include <QObject>
#include <QByteArray>
#include <QDebug>
#include <iostream>

class MessageParser: public QObject
{
    Q_OBJECT
public:
    enum class State{
        START,
        EVENT,
        VALUE,
        END
    };

    struct Event{
        QString eventName;
        QString value;

    };

    explicit MessageParser(QObject *parent = nullptr);

    char eventStart() const;
    void eventStart(char eventStart);

    char eventValueDivider() const;
    void eventValueDivider(char eventValueDivider);

    char eventEnd() const;
    void eventEnd(char eventEnd);

    void parseData(char byte);
    void parseData(const QByteArray& data);

    friend std::ostream& operator<<(std::ostream& out, const Event& event);
    friend QDebug operator<<(QDebug debug, const Event& event);

signals:
    void messageParsed(Event event);

public slots:

private:
    MessageParser(const MessageParser&);

    char mEventStart;
    char mEventValueDivider;
    char mEventEnd;

    State mCurrentState;
    Event mCurrentEvent;
};

