#include "localsocketconnection.h"
#include "debugmessagelist.h"
#include <QDebug>
#include <QJsonObject>
#include <algorithm>


extern DebugMessageList debugMessageList;


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
    if(!mPreferences[PREFERENCE_SOCKET_NAME].isNull() && !mPreferences[PREFERENCE_SOCKET_NAME].toString().isEmpty()){
        mLocalSocket.setServerName(mPreferences[PREFERENCE_SOCKET_NAME].toString());
        qDebug() << "Connected to server";
        mLocalSocket.open();
    }
}

void LocalSocketConnection::disconnectImpl(){
    if(isConnected())
        mLocalSocket.close();
}

bool LocalSocketConnection::isConnected() const{

    return mLocalSocket.isOpen();
}

void LocalSocketConnection::parseDebug(DebugInfoDirection::DebugInfoDirection direction, const QByteArray &data){
    QString result;

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

    debugMessageList.appendItem(result);

}

QJsonObject LocalSocketConnection::serialize(){
    QJsonObject result;

    result.insert(LocalSocketConnection::PREFERENCE_SOCKET_NAME, mPreferences[LocalSocketConnection::PREFERENCE_SOCKET_NAME].toString());

    return result;
}

void LocalSocketConnection::deserialize(const QJsonObject &data){

    if(!data.value(LocalSocketConnection::PREFERENCE_SOCKET_NAME).isNull())
        mPreferences[LocalSocketConnection::PREFERENCE_SOCKET_NAME] = data.value(LocalSocketConnection::PREFERENCE_SOCKET_NAME).toString();

    emit preferencesChanged(mPreferences);
}
