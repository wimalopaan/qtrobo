#ifdef Q_OS_ANDROID

#pragma once
#include <QThread>

#include <QtAndroidExtras>
#include "serialconnection.h"


class MobileConnection:public QThread
{
public:
    MobileConnection(QAndroidJniObject& mSerialConnectionMobile,SerialConnection &mSerialConnection);
    QAndroidJniObject& mSerialConnectionMobile;
    SerialConnection& mSerialConnection;

    void run();
};

#endif
