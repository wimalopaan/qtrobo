#include "mobileconnection.h"

#ifdef Q_OS_ANDROID
MobileConnection::MobileConnection(QAndroidJniObject& mSerialConnectionMobile,SerialConnection& mSerialConnection):mSerialConnectionMobile{mSerialConnectionMobile},mSerialConnection{mSerialConnection}{

};
#endif

void MobileConnection::run(){
#ifdef Q_OS_ANDROID
    while (true) {
        mSerialConnectionMobile.callMethod<jboolean>("hasConnected");
        mSerialConnection.startHeartbeat();
        emit mSerialConnection.connectionStateChanged(mSerialConnection.isConnected());
        break;
    }
#endif
}

