#include "mobiledata.h"
#include "QtDebug"

MobileData::MobileData(QThread &thread,QAndroidJniObject &serialData):thread{thread},serialData{serialData}
{
}


void MobileData::checkDataBuffer(){
    while(true){
       if (serialData.callMethod<jboolean>("readyRead")== JNI_TRUE){
           emit dataToRead();
       }
       thread.msleep(10);
    }

}
