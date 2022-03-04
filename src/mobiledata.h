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
#ifdef Q_OS_ANDROID
    QAndroidJniObject& mSerialConnectionMobile;
    MobileData(MessageParser& mParser, QAndroidJniObject& mSerialConnectionMobile);
#endif
#ifndef Q_OS_ANDROID
    // only to prevent compiler warning
   MobileData(MessageParser& parser);
#endif
    MessageParser& mParser;



    void run();
    void readyRead();

    signals:
        void dataToRead();


};



