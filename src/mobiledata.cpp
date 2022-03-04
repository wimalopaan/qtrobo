#include "mobiledata.h"
#include "QtDebug"
#include "messageparser.h"

#ifdef Q_OS_ANDROID
MobileData::MobileData(MessageParser& parser,QAndroidJniObject& mSerialConnectionMobile):mSerialConnectionMobile{mSerialConnectionMobile},mParser{parser}
{
}
#endif

#ifndef Q_OS_ANDROID
// only to prevent compiler warning
MobileData::MobileData(MessageParser& parser):mParser{parser}
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



