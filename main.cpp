#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QSerialPort>
#include "qtrobo.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app{argc, argv};

    QQuickStyle::setStyle("Material");
    QCoreApplication::setOrganizationName("hskl");
    QCoreApplication::setOrganizationDomain("www.hs-kl.de");
    QCoreApplication::setApplicationName("QtRobo");

    qmlRegisterType<QSerialPort>("QSerialPort", 0, 1, "QSerialPort");

    qmlRegisterUncreatableMetaObject(ConnectionType::staticMetaObject, "QtRobo.ConnectionType", 1, 0, "ConnectionType", "Error: only enums");
    qRegisterMetaType<ConnectionType::ConnectionType>("ConnectionType");

    qmlRegisterUncreatableMetaObject(DebugInfoDirection::staticMetaObject, "QtRobo.DebugInfoDirection", 1, 0, "DebugInfoDirection", "Error: only enums");
    qRegisterMetaType<DebugInfoDirection::DebugInfoDirection>("DebugInfoDirection");

    QtRobo qtRobo;
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("qtRobo", &qtRobo);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
