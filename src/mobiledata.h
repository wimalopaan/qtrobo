#pragma once
#include <QObject>
#include <QThread>
#include <QtAndroidExtras>



class MobileData : public QObject
{
    Q_OBJECT
public:
    QThread &thread;
    QAndroidJniObject serialData;

    MobileData(QThread &thread, QAndroidJniObject &serialData);

public slots:
   void checkDataBuffer();


signals:
    void dataToRead();
};


