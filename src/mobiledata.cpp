#ifdef Q_OS_ANDROID

#include "mobiledata.h"
#include "QtDebug"
#include "messageparser.h"


MobileData::MobileData(MessageParser& mParser,QAndroidJniObject& mSerialConnectionMobile):mParser{mParser},mSerialConnectionMobile{mSerialConnectionMobile}
{
}

void MobileData ::run(){
    while(true){
        readyRead();
    }
}


void MobileData::readyRead(){
        qDebug() << "called";
        mSerialConnectionMobile.callMethod<jboolean>("readyRead");
        emit dataToRead();
}

#endif

