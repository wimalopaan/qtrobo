#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include "serialconnection.h"
#include "layoutpersist.h"

int main(int argc, char *argv[])
{
    SerialConnection serialConnection;
    LayoutPersist layoutPersist;

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");
    QCoreApplication::setOrganizationName("hskl");
    QCoreApplication::setOrganizationDomain("www.hs-kl.de");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("serialConnection", &serialConnection);
    engine.rootContext()->setContextProperty("layoutPersist", &layoutPersist);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
