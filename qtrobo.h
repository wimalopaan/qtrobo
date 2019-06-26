#pragma once
#include <QObject>
#include <QJsonObject>
#include <QTranslator>
#include <QLocale>

#include <map>
#include <memory>

#include "persistance.h"
#include "connection.h"

class QtRobo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(Connection* connection READ connection NOTIFY connectionChanged)
    Q_PROPERTY(Persistance* persistance READ persistance NOTIFY persistanceChanged)
    Q_PROPERTY(ConnectionType::ConnectionType connectionType MEMBER mConnectionType NOTIFY connectionChanged)
    Q_PROPERTY(QLocale::Language language READ language WRITE language NOTIFY languageChanged)

public:
    explicit QtRobo(QObject *parent = nullptr);
    QtRobo(const QtRobo &other) = delete;
    QtRobo(QtRobo &&other) = delete;

    ~QtRobo();

    Connection * connection();
    Persistance * persistance();

    void language(const QLocale::Language &language);
    QLocale::Language language();

    QtRobo& operator=(const QtRobo &other) = delete;
    QtRobo& operator=(QtRobo &&other) = delete;

signals:
    void connectionChanged();
    void persistanceChanged();
    void languageChanged();

public slots:
    void onPersisting(QJsonObject &data);
    void onRestoring(QJsonObject data);

private:
    std::map<ConnectionType::ConnectionType, std::unique_ptr<Connection>> mConnections;
    ConnectionType::ConnectionType mConnectionType = ConnectionType::ConnectionType::Serial;
    Persistance mPersistance;
    QTranslator mTranslator;
    QLocale::Language mLanguage{QLocale::Language::AnyLanguage};

    static inline const QString LANGUAGE_DIRECTORY_NAME{"i18n"};
    static inline const QString PERSISTANCE_SECTION_SERIAL_PORT{"serialport"};
    static inline const QString PERSISTANCE_SECTION_LOCAL_SOCKET{"localsocket"};
};

