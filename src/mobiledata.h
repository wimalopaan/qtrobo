#ifdef Q_OS_ANDROID
#pragma once
#include <QObject>
#include <QThread>
#include <QtAndroidExtras>
#include "messageparser.h"
#include "connection.h"




class MobileData :  public QThread
{
    Q_OBJECT

public:
    MessageParser& mParser;
    QAndroidJniObject& mSerialConnectionMobile;

    MobileData(MessageParser& mParser, QAndroidJniObject& mSerialConnectionMobile);

    void run();
    void readyRead();

    signals:
        void dataToRead();


};

#endif

