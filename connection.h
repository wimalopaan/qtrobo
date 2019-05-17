#pragma once
#include <QObject>
#include <QString>
#include <QTimer>
#include <QVariant>
#include <QVariantMap>

#include "messageparser.h"

class Connection : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString data READ data NOTIFY dataChanged)
    Q_PROPERTY(QString eventName READ eventName NOTIFY dataChanged)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionStateChanged)
    Q_PROPERTY(QString heartbeatRequest MEMBER mHeartbeatRequest NOTIFY heartbeatRequestChanged)
    Q_PROPERTY(QString heartbeatResponse MEMBER mHeartbeatResponse NOTIFY heartbeatResponseChanged)
    Q_PROPERTY(int heartbeatTimeout MEMBER mHeartbeatTimeout NOTIFY heartbeatTimeoutChanged)
    Q_PROPERTY(bool heartbeatStatus MEMBER mHeartbeatStatus NOTIFY heartbeatTriggered)
    Q_PROPERTY(bool heartbeatEnabled MEMBER mHeartbeatEnabled NOTIFY heartbeatEnabledChanged)
    Q_PROPERTY(MessageParser* messageParser READ messageParser NOTIFY messageParserChanged)

public:
    explicit Connection(QObject *parent = nullptr);
    Connection(const Connection &connection);
    ~Connection();

    const QString& data() const;
    const QString& eventName() const;
    MessageParser* messageParser();

    virtual bool isConnected() const = 0;
    virtual QByteArray read() = 0;

    Q_INVOKABLE void write(const QString &eventName);
    Q_INVOKABLE void write(const QString &eventName, const QVariant &data);

    Q_INVOKABLE virtual void connect(const QVariantMap &preferences) = 0;
    Q_INVOKABLE virtual void disconnect() = 0;

    Connection& operator=(Connection& other);

    friend void swap(Connection& lhs, Connection& rhs);

signals:
    void dataChanged(const QString &eventName, const QString &data);
    void heartbeatTriggered(bool heartbeatStatus);
    void heartbeatRequestChanged(const QString &heartbeatRequest);
    void heartbeatResponseChanged(const QString &heartbeatResponse);
    void heartbeatTimeoutChanged(int heartbeatTimeout);
    void heartbeatEnabledChanged(bool heartbeatEnabled);
    void connectionStateChanged(bool isConnected);
    void messageParserChanged(const MessageParser *messageParser);

public slots:
    void onParsedDataReady(const MessageParser::Event &event);
    void onHeartbeatTriggered();
    void onReadyRead();

protected:
    MessageParser mParser;
    MessageParser::Event mEvent;

    QTimer mHeartbeat;
    QString mHeartbeatRequest;
    QString mHeartbeatResponse;
    int mHeartbeatTimeout;
    bool mHeartbeatStatus;
    bool mHeartbeatEnabled;

    virtual void writeImpl(const QString &eventName) = 0;
};
