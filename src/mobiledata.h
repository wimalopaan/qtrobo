#pragma once
#include <QObject>
#include <QThread>
#include "messageparser.h"
#include "connection.h"

#ifdef Q_OS_ANDROID
    #include <QtAndroidExtras>
#endif




class MobileData :  public QThread
{
    Q_OBJECT

public:
    MessageParser& mParser;
#ifdef Q_OS_ANDROID
    QAndroidJniObject& mSerialConnectionMobile;

    MobileData(MessageParser& mParser, QAndroidJniObject& mSerialConnectionMobile);
#endif

    void run();
    void readyRead();

    signals:
        void dataToRead();


};



