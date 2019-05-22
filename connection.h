#pragma once
#include <QObject>
#include <QString>
#include <QTimer>
#include <QVariant>
#include <QVariantMap>

#include "messageparser.h"

namespace ConnectionType{
    Q_NAMESPACE

    enum class ConnectionType{
        Serial,
        Socket
    };

    Q_ENUM_NS(ConnectionType)
};

class Connection : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString data READ data NOTIFY dataChanged)
    Q_PROPERTY(QString eventName READ eventName NOTIFY dataChanged)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionStateChanged)
    Q_PROPERTY(QString heartbeatRequest MEMBER mHeartbeatRequest NOTIFY heartbeatRequestChanged)
    Q_PROPERTY(QString heartbeatResponse MEMBER mHeartbeatResponse NOTIFY heartbeatResponseChanged)
    Q_PROPERTY(uint heartbeatTimeout MEMBER mHeartbeatTimeout NOTIFY heartbeatTimeoutChanged)
    Q_PROPERTY(bool heartbeatStatus MEMBER mHeartbeatStatus NOTIFY heartbeatTriggered)
    Q_PROPERTY(bool heartbeatEnabled MEMBER mHeartbeatEnabled NOTIFY heartbeatEnabledChanged)
    Q_PROPERTY(MessageParser* messageParser READ messageParser NOTIFY messageParserChanged)
    Q_PROPERTY(QVariantMap preferences MEMBER mPreferences NOTIFY preferencesChanged)
    Q_PROPERTY(QString debug MEMBER mDebug NOTIFY debugChanged)

public:
    explicit Connection(QObject *parent = nullptr);
    Connection(const Connection &connection);
    ~Connection();

    const QString& data() const;
    const QString& eventName() const;
    MessageParser* messageParser();
    void enableHeartbeat();

    virtual bool isConnected() const = 0;
    virtual QByteArray read() = 0;


    Q_INVOKABLE void write(const QString &eventName);
    Q_INVOKABLE void write(const QString &eventName, const QVariant &data);

    Q_INVOKABLE void connect();
    Q_INVOKABLE void disconnect();

    Connection& operator=(Connection& other);

    friend void swap(Connection& lhs, Connection& rhs);

signals:
    void dataChanged(const QString &eventName, const QString &data);
    void heartbeatTriggered(bool heartbeatStatus);
    void heartbeatRequestChanged(const QString &heartbeatRequest);
    void heartbeatResponseChanged(const QString &heartbeatResponse);
    void heartbeatTimeoutChanged(uint heartbeatTimeout);
    void heartbeatEnabledChanged(bool heartbeatEnabled);
    void connectionStateChanged(bool isConnected);
    void messageParserChanged(const MessageParser *messageParser);
    void preferencesChanged(const QVariantMap &preferences);
    void debugChanged(const QString& debug);

public slots:
    void onParsedDataReady(const MessageParser::Event &event);
    void onHeartbeatTriggered();
    void onReadyRead();

protected:
    MessageParser mParser;
    MessageParser::Event mEvent;

    QTimer mHeartbeat;
    QVariantMap mPreferences;
    uint mHeartbeatTimeout;
    bool mHeartbeatStatus;
    QString mHeartbeatRequest;
    QString mHeartbeatResponse;
    bool mHeartbeatEnabled;
    QString mDebug;

    virtual void writeImpl(const QString &eventName) = 0;
    virtual void connectImpl() = 0;
    virtual void disconnectImpl() = 0;
    virtual void parseDebug(const QString& tag, const QByteArray& data) = 0;

private:
    static const bool DEFAULT_HEARTBEAT_ENABLED = false;
    static const uint DEFAULT_HEARTBEAT_TIMEOUT = 500;
    static inline const QString DEFAULT_HEARTBEAT_REQUEST{"PING"};
    static inline const QString DEFAULT_HEARTBEAT_RESPONSE{"PONG"};

    static const char DEFAULT_EVENT_START = '$';
    static const char DEFAULT_EVENT_VALUE_DIVIDER = ':';
    static const char DEFAULT_EVENT_END = '\n';
};
