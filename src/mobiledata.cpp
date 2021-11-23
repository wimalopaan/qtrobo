#include "mobiledata.h"
#include "QtDebug"
#include "messageparser.h"

#ifdef Q_OS_ANDROID
MobileData::MobileData(MessageParser& mParser,QAndroidJniObject& mSerialConnectionMobile):mParser{mParser},mSerialConnectionMobile{mSerialConnectionMobile}
{
}
#endif

void MobileData ::run(){
    while(true){
        readyRead();
    }
}


void MobileData::readyRead(){
#ifdef Q_OS_ANDROID
        qDebug() << "called";
        mSerialConnectionMobile.callMethod<jboolean>("readyRead");
        emit dataToRead();
#endif
}



