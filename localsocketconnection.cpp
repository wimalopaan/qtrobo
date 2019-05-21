#include "localsocketconnection.h"
#include <QDebug>

LocalSocketConnection::LocalSocketConnection(QObject *parent) : Connection(parent)
{
    QObject::connect(&mLocalSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
}

QByteArray LocalSocketConnection::read(){
    return mLocalSocket.readAll();
}

void LocalSocketConnection::writeImpl(const QString &eventName){
    const char* dataBytes = eventName.toStdString().c_str();

    if(mParser.eventEnd() == '\0')
        mLocalSocket.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
    else
        mLocalSocket.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
}

void LocalSocketConnection::connectImpl(){
    mLocalSocket.setServerName(mPreferences["socketName"].toString());
    qDebug() << "Connected to server";
    mLocalSocket.open();

    emit connectionStateChanged(isConnected());
}

void LocalSocketConnection::disconnectImpl(){
    if(isConnected())
        mLocalSocket.close();

    emit connectionStateChanged(isConnected());
}

bool LocalSocketConnection::isConnected() const{

    return mLocalSocket.isOpen();
}

void LocalSocketConnection::parseDebug(const QString& tag, const QByteArray &data){
    QString result = tag;
    result.append("\u27A1");

    for(char byte : data){
        switch(byte){
            case '\n':
                result.append("\\n");
                break;
            case '\r':
                result.append("\\r");
                break;
            case '\0':
                result.append("\\0");
                break;
            default:
                result.append(byte);
        }
    }

    emit debugChanged(result);
}
