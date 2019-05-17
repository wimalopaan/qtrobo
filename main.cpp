#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QSerialPort>
#include "serialconnection.h"
#include "layoutpersist.h"
#include "enumdefinitions.h"
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

    QtRobo qtRobo;
    QQmlApplicationEngine engine;
    LayoutPersist layoutPersist;

    engine.rootContext()->setContextProperty("qtRobo", &qtRobo);
    //engine.rootContext()->setContextProperty("serialConnection", &serialConnection);
    engine.rootContext()->setContextProperty("layoutPersist", &layoutPersist);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
