#ifdef Q_OS_ANDROID

#include "mobileconnection.h"

MobileConnection::MobileConnection(QAndroidJniObject& mSerialConnectionMobile,SerialConnection& mSerialConnection):mSerialConnectionMobile{mSerialConnectionMobile},mSerialConnection{mSerialConnection}{

};

void MobileConnection::run(){
    while (true) {
        mSerialConnectionMobile.callMethod<jboolean>("hasConnected");
        mSerialConnection.startHeartbeat();
        emit mSerialConnection.connectionStateChanged(mSerialConnection.isConnected());
        break;
    }
}
#endif
