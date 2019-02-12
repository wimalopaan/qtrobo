#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QSerialPort>
#include "serialconnection.h"
#include "layoutpersist.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QCoreApplication::setOrganizationName("hskl");
    QCoreApplication::setOrganizationDomain("www.hs-kl.de");
    QCoreApplication::setApplicationName("QtRobo");

    qmlRegisterType<QSerialPort>("QSerialPort", 0, 1, "QSerialPort");

    QQmlApplicationEngine engine;
    SerialConnection serialConnection;
    LayoutPersist layoutPersist;

    engine.rootContext()->setContextProperty("serialConnection", &serialConnection);
    engine.rootContext()->setContextProperty("layoutPersist", &layoutPersist);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
