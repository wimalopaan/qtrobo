#pragma once
#include <QThread>
#include "serialconnection.h"


#ifdef Q_OS_ANDROID
    #include <QtAndroidExtras>
#endif


class MobileConnection:public QThread
{
public:
#ifdef Q_OS_ANDROID
    MobileConnection(QAndroidJniObject& mSerialConnectionMobile,SerialConnection &mSerialConnection);
    QAndroidJniObject& mSerialConnectionMobile;
    SerialConnection& mSerialConnection;
#endif
    void run();
};


