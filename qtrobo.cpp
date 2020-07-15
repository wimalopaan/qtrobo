#include "qtrobo.h"
#include "serialconnection.h"
#include "localsocketconnection.h"
#include "bluetoothconnection.h"
#include <QCoreApplication>

QtRobo::QtRobo(QObject *parent) : QObject(parent){
    mConnections[ConnectionType::ConnectionType::Serial] = std::make_unique<SerialConnection>(this);
    mConnections[ConnectionType::ConnectionType::Socket] = std::make_unique<LocalSocketConnection>(this);
    mConnections[ConnectionType::ConnectionType::Bluetooth] = std::make_unique<BluetoothConnection>(this);

    QObject::connect(&mPersistance, &Persistance::serializeConnection, this, &QtRobo::onPersisting);
    QObject::connect(&mPersistance, &Persistance::deserializeConnection, this, &QtRobo::onRestoring);

    QLocale systemLocal = QLocale::system();
    language(systemLocal.language());
}

QtRobo::~QtRobo(){

}

Connection * QtRobo::connection(){
    return mConnections[mConnectionType].get();
}

Persistance * QtRobo::persistance(){
    return &mPersistance;
}

void QtRobo::language(const QLocale::Language &language){

    if(mLanguage != QLocale::Language::AnyLanguage)
        QCoreApplication::removeTranslator(&mTranslator);

    bool loaded{false};

    QString absoluteLanguageDir;
    absoluteLanguageDir = QString("%1/%2")
            .arg(QCoreApplication::applicationDirPath())
            .arg(LANGUAGE_DIRECTORY_NAME);

    switch(language){
        case QLocale::Language::German:
            loaded = mTranslator.load("de-DE.qm", absoluteLanguageDir);
        break;

        case QLocale::Language::English:
        default:
            loaded = mTranslator.load("en-EN.qm", absoluteLanguageDir);
        break;
    }

    qDebug() << "Loaded language file [" << language << "]:" << loaded;

    if(loaded){
        QCoreApplication::installTranslator(&mTranslator);
    }
}

QLocale::Language QtRobo::language(){
    return mLanguage;
}

void QtRobo::onPersisting(QJsonObject &data){
    data.insert(QtRobo::PERSISTANCE_SECTION_SERIAL_PORT, mConnections[ConnectionType::ConnectionType::Serial]->serialize());
    data.insert(QtRobo::PERSISTANCE_SECTION_LOCAL_SOCKET, mConnections[ConnectionType::ConnectionType::Socket]->serialize());
}

void QtRobo::onRestoring(QJsonObject data){
    auto serialPortObject = data.find(QtRobo::PERSISTANCE_SECTION_SERIAL_PORT).value();
    auto localSocketObject = data.find(QtRobo::PERSISTANCE_SECTION_LOCAL_SOCKET).value();

    if(!serialPortObject.isNull() && serialPortObject.isObject())
        mConnections[ConnectionType::ConnectionType::Serial]->deserialize(serialPortObject.toObject());

    if(!localSocketObject.isNull() && localSocketObject.isObject())
        mConnections[ConnectionType::ConnectionType::Socket]->deserialize(localSocketObject.toObject());
}
