#include "qtrobo.h"
#include "util.h"
#include "debugmessagemodel.h"
#include "debugmessagelist.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QSerialPort>
#include <QLocale>
#include <QDebug>
#include <QLoggingCategory>

DebugMessageList debugMessageList{};

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app{argc, argv};

    qmlRegisterType<DebugMessageModel>("DebugMessage",1,0,"DebugMessageModel");
    qmlRegisterUncreatableType<DebugMessageList>("DebugMessage",1,0,"DebugMessageList",
       QStringLiteral("DebugMessageList should not be created in QML"));



    QQuickStyle::setStyle("Material");
    QCoreApplication::setOrganizationName("hskl");
    QCoreApplication::setOrganizationDomain("www.hs-kl.de");
    QCoreApplication::setApplicationName("QtRobo");

    qmlRegisterType<QSerialPort>("QSerialPort", 0, 1, "QSerialPort");
    qmlRegisterUncreatableType<QLocale>("QLocale", 0, 1, "QLocale", "Error: only enum definitions used");

    qmlRegisterUncreatableMetaObject(ConnectionType::staticMetaObject, "QtRobo.ConnectionType", 1, 0, "ConnectionType", "Error: only enums");
    qRegisterMetaType<ConnectionType::ConnectionType>("ConnectionType");

    qmlRegisterUncreatableMetaObject(DebugInfoDirection::staticMetaObject, "QtRobo.DebugInfoDirection", 1, 0, "DebugInfoDirection", "Error: only enums");
    qRegisterMetaType<DebugInfoDirection::DebugInfoDirection>("DebugInfoDirection");

    QtRobo qtRobo;
    Util util;
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("debugMessageList", &debugMessageList);
    engine.rootContext()->setContextProperty("qtRobo", &qtRobo);
    engine.rootContext()->setContextProperty("qrRoboUtil", &util);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
