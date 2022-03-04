#pragma once
#include <QThread>

#ifdef Q_OS_ANDROID
    #include <QtAndroidExtras>
#endif
#include "serialconnection.h"


class MobileConnection:public QThread
{
public:
#ifdef Q_OS_ANDROID

    MobileConnection(QAndroidJniObject& mSerialConnectionMobile,SerialConnection &mSerialConnection);
    QAndroidJniObject& mSerialConnectionMobile;
#endif

#ifndef Q_OS_ANDROID
    // only to prevent compiler warning

   MobileConnection(SerialConnection& connection);
#endif

    SerialConnection& mSerialConnection;
    void run();
};


