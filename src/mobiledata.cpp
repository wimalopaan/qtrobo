#include "mobiledata.h"
#include "QtDebug"
#include "messageparser.h"

#ifdef Q_OS_ANDROID
MobileData::MobileData(MessageParser& parser,QAndroidJniObject& mSerialConnectionMobile):mSerialConnectionMobile{mSerialConnectionMobile},mParser{parser}
{
}
#endif


void MobileData ::run(){
#ifdef Q_OS_ANDROID
    while(true){
        readyRead();
    }
#endif
}

#ifdef Q_OS_ANDROID
void MobileData::readyRead(){
        qDebug() << "called";
        mSerialConnectionMobile.callMethod<jboolean>("readyRead");
        emit dataToRead();
}
#endif



