#include "javascriptparser.h"
#include <QDebug>

JavaScriptParser::JavaScriptParser(QObject *parent) : QObject(parent)
{}

QVariantMap JavaScriptParser::runScript(const QString &eventName, const QString &value, QString script){
    qDebug() << "Parsing";
    auto scriptEngineResult = mScriptEngine.checkSyntax(script);
    QVariantMap result;

    if(scriptEngineResult.state() == QScriptSyntaxCheckResult::State::Valid){

        qDebug() << "Valid";
        mScriptEngine.globalObject().setProperty("event", eventName);
        mScriptEngine.globalObject().setProperty("value", value);

        mScriptEngine.evaluate(script).call();

        result["value"] = mScriptEngine.globalObject().property("value").toString();
        result["event"] = mScriptEngine.globalObject().property("event").toString();

        qDebug() << "Event: " << eventName << "Value: " << value;
    }
    else
        qDebug() << "Error: " << scriptEngineResult.errorMessage();

    return result;
}
