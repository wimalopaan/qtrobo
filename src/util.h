#pragma once
#include <QtGlobal>
#include <QObject>

class Util: public QObject{
    Q_OBJECT
public:
    Q_INVOKABLE static constexpr bool isMobileDevice(){
#ifdef Q_OS_ANDROID
    return true;
#elif
    return false;
#endif
}
};
