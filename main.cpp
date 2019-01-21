#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "serialconnection.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //qmlRegisterType<SerialConnection>("org.hskl.serialconnection", 1, 0, "SerialConnection");
    QQuickStyle::setStyle("Universal");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    SerialConnection serialConnection;
    engine.rootContext()->setContextProperty("serialConnection", &serialConnection);
    return app.exec();
}
