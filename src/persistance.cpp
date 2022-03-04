#include "persistance.h"
#include "util.h"

#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFileInfo>
#include <QDebug>
#include <QStandardPaths>

Persistance::Persistance(QObject *parent) :
    QObject(parent)
{}

Persistance::~Persistance(){}

bool Persistance::isFilenameValid() const{
    if(Util::isMobileDevice()){
            Util::checkAndRequestPermission();
            qDebug() << mFilename.fileName();
            QString androidFilePath = QString("%1/%2").arg("/storage/emulated/0/QtRobo/", mFilename.fileName());
            QFileInfo layoutFileInfo{QFile(androidFilePath)};
            bool isValid = layoutFileInfo.exists() && layoutFileInfo.isFile() && layoutFileInfo.isWritable() && 0 == layoutFileInfo.suffix().compare("json", Qt::CaseInsensitive);
            qDebug() << "Is valid: " << isValid;
            return isValid;
        }else{
            QFileInfo layoutFileInfo{mFilename.toLocalFile()};
            bool isValid = layoutFileInfo.exists() && layoutFileInfo.isFile() && layoutFileInfo.isWritable() && 0 == layoutFileInfo.suffix().compare("json", Qt::CaseInsensitive);
            return isValid;
        }
}

QUrl Persistance::filename() const{
    return mFilename;
}

void Persistance::filename(const QUrl& filename){
    mFilename = filename;
    emit filenameValidChanged(isFilenameValid());
}

bool Persistance::qtRoboFolderSelectedOnMobile() {
    #ifdef Q_OS_ANDROID
    QSettings settings;
    return settings.value("openedFile").toInt() == 1;
    #else
      //only to prevent compiler warning
      return true;
    #endif

}

void Persistance::restore(){
    qDebug() << "R: " << mFilename << mFilename.fileName();

    auto layoutFile = [&]()->QFile{
        if(Util::isMobileDevice()){
            #ifdef Q_OS_ANDROID
            Util::checkAndRequestPermission();
            const QString androidFilePath = QString("%1/%2").arg("/storage/emulated/0/QtRobo/", mFilename.fileName());
            QFileInfo info = QFileInfo(androidFilePath);


            QSettings settings;
            if (info.exists()){
                settings.setValue("openedFile",1);
            }
            qDebug() << settings.value("openedFile").toInt();

            return QFile{androidFilePath};
            #endif
        }else{
            return QFile{mFilename.toLocalFile()};
        }
    }();

    layoutFile.open(QIODevice::ReadOnly);


    if(layoutFile.isOpen() && layoutFile.isReadable()){
        qDebug() << "Is open";
        QJsonObject rootObject =  QJsonDocument::fromJson(layoutFile.readAll()).object();

        auto layoutObject = rootObject.find(Persistance::PERSISTANCE_SECTION_LAYOUT).value();

        if(!layoutObject.isNull() && layoutObject.isArray()){
            mLayout = layoutObject.toArray();
            emit layoutChanged(mLayout);
        }

        auto settingsObject = rootObject.find(Persistance::PERSISTANCE_SECTION_SETTINGS).value();

        if(!settingsObject.isNull() && settingsObject.isObject())
            emit deserializeConnection(settingsObject.toObject());
    }
}

void Persistance::persist(){

    qDebug() << "R: " << mFilename << mFilename.fileName();


    QJsonObject documentObject;
    QJsonObject connections;

    emit serializeConnection(connections);

    documentObject.insert(Persistance::PERSISTANCE_SECTION_LAYOUT, mLayout);
    documentObject.insert(Persistance::PERSISTANCE_SECTION_SETTINGS, connections);


    auto layoutFile = [&]()->QFile{
        if(Util::isMobileDevice()){
            #ifdef Q_OS_ANDROID
            Util::checkAndRequestPermission();

            QDir dir("/storage/emulated/0/QtRobo");
            if (!dir.exists())
                dir.mkpath(".");

            const QString androidFilePath = QString("%1/%2").arg("/storage/emulated/0/QtRobo", mFilename.fileName().split(":").last());
            return QFile{androidFilePath};
            #endif
        }else{
            return QFile{mFilename.toLocalFile()};
        }
    }();

    layoutFile.open(QIODevice::ReadWrite | QIODevice::Truncate);

    qDebug() << "Android Path(" << layoutFile.isWritable() << "):" << layoutFile.fileName();
    if(layoutFile.isOpen() && layoutFile.isWritable()){
        qDebug() << "Is open";
        QJsonDocument document{documentObject};

        layoutFile.write(document.toJson());
    }

    layoutFile.close();

}


Persistance::Persistable::~Persistable(){}
