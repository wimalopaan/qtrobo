#include "mobileconnection.h"

#ifdef Q_OS_ANDROID
MobileConnection::MobileConnection(QAndroidJniObject& mSerialConnectionMobile,SerialConnection& mSerialConnection):mSerialConnectionMobile{mSerialConnectionMobile},mSerialConnection{mSerialConnection}{

};
#endif

#ifndef Q_OS_ANDROID
//only to prevent compiler warning
MobileConnection::MobileConnection(SerialConnection& connection):mSerialConnection{connection}
{

}
#endif


void MobileConnection::run(){
#ifdef Q_OS_ANDROID
    while (true) {
        mSerialConnectionMobile.callMethod<jboolean>("hasConnected");
        emit mSerialConnection.connectedFromJava();
        emit mSerialConnection.connectionStateChanged(mSerialConnection.isConnected());
        mSerialConnectionMobile.callMethod<jboolean>("hasDisconnected");
    }
#endif
}

