#pragma once
#include <QtGlobal>
#include <QObject>

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

class Util: public QObject{
    Q_OBJECT
public:
    Q_INVOKABLE static constexpr bool isMobileDevice(){
#ifdef Q_OS_ANDROID
    return true;
#else
    return false;
#endif
}

    static bool checkAndRequestPermission(){
        const auto permissionDenied = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE") == QtAndroid::PermissionResult::Denied ||
                QtAndroid::checkPermission("android.permission.READ_EXTERNAL_STORAGE") == QtAndroid::PermissionResult::Denied ;
        if(permissionDenied){
            QtAndroid::requestPermissionsSync(QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE" << "android.permission.READ_EXTERNAL_STORAGE");
        }
    }
};
