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
    void readyRead();

    MessageParser& mParser;
#endif
    void run();
signals:
    void dataToRead();
};



