#pragma once
#include <QObject>
#include <QQmlApplicationEngine>

namespace ConnectionType{
    Q_NAMESPACE

    enum class ConnectionType{
        Serial,
        Pipe,
        Socket
    };

    Q_ENUM_NS(ConnectionType)
};

