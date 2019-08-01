#pragma once

#include <QObject>
#include <QString>
#include <QScriptEngine>
#include <QVariantMap>
#include "messageparser.h"

class JavaScriptParser : public QObject
{
    Q_OBJECT

public:
    explicit JavaScriptParser(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap runScript(const QString &eventName, const QString &value, QString script);

public slots:

private:
    QScriptEngine mScriptEngine;
};
