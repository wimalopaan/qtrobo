QT += qml quick serialport quickcontrols2 charts script bluetooth
CONFIG += c++17

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

android{
    QT += androidextras
}

SOURCES += \
    bluetoothconnection.cpp \
    connection.cpp \
    debugmessagelist.cpp \
    debugmessagemodel.cpp \
    javascriptparser.cpp \
    localsocketconnection.cpp \
        main.cpp \
    mobileconnection.cpp \
    mobiledata.cpp \
    persistance.cpp \
    qtrobo.cpp \
    serialconnection.cpp \
    messageparser.cpp \
    util.cpp \

lupdate_only{
    SOURCES += *.qml
}

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH +=

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    bluetoothconnection.h \
    connection.h \
    debugmessagelist.h \
    debugmessagemodel.h \
    javascriptparser.h \
    localsocketconnection.h \
    mobileconnection.h \
    mobiledata.h \
    persistance.h \
    qtrobo.h \
    serialconnection.h \
    messageparser.h \
    util.h

DISTFILES += \
    ../../../../Downloads/FNM9MXQIJUCPKBD.jar \
    ComponentsModel.qml \
    DraggableButtonMenu.qml \
    DraggableCircularSpeedbar.qml \
    DraggableSpeedGauge.qml \
    DraggableSpeedGaugeMenu.qml \
    DraggableSpeedbar.qml \
    DraggableSpeedbar.qml \
    DraggableSpeedbarMenu.qml \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/libs/physicaloidlibrary.jar \
    android/res/values/libs.xml \
    android/settings.gradle \
    android/src/Connected.java \
    android/src/Data.java \
    android/src/Receiver.java \
    android/src/Sender.java \
    android/src/SerialConnector.java \
    android/src/UsbBroadcastReceiver.java \
    todo.txt \
    placeholder_image.png

TRANSLATIONS += i18n/de-DE.ts \
    i18n/en-EN.ts

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
