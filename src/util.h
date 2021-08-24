#pragma once
#include <QtGlobal>
#include <QObject>

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QtAndroidExtras>
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

    static void checkAndRequestPermission(){
#ifdef Q_OS_ANDROID
        const auto writePermissionDenied = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE") == QtAndroid::PermissionResult::Denied;
        const auto readPermissionDenied = QtAndroid::checkPermission("android.permission.READ_EXTERNAL_STORAGE") == QtAndroid::PermissionResult::Denied ;
        auto permissionList = QStringList{};

        if(writePermissionDenied){
            permissionList << "android.permission.WRITE_EXTERNAL_STORAGE";
        }

        if(readPermissionDenied){
            permissionList << "android.permission.READ_EXTERNAL_STORAGE";
        }

        if(!permissionList.isEmpty()){
            QtAndroid::requestPermissionsSync(permissionList);
        }
#endif
    }
};
