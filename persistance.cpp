#include "persistance.h"
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFileInfo>
#include <QDebug>

Persistance::Persistance(QObject *parent) :
    QObject(parent)
{}

Persistance::~Persistance(){}

bool Persistance::isFilenameValid() const{
    QFileInfo layoutFileInfo{mFilename.toLocalFile()};
    bool isValid = layoutFileInfo.exists() && layoutFileInfo.isFile() && layoutFileInfo.isWritable() && 0 == layoutFileInfo.suffix().compare("json", Qt::CaseInsensitive);
    return isValid;
}

QUrl Persistance::filename() const{
    return mFilename;
}

void Persistance::filename(const QUrl& filename){
    mFilename = filename;
    emit filenameValidChanged(isFilenameValid());
}

void Persistance::restore(){
    QFile layoutFile{mFilename.toLocalFile()};
    layoutFile.open(QIODevice::ReadOnly);

    if(layoutFile.isOpen() && layoutFile.isReadable()){
        QJsonObject rootObject =  QJsonDocument::fromJson(layoutFile.readAll()).object();

        auto layoutObject = rootObject.find("layout").value();

        if(!layoutObject.isNull() && layoutObject.isArray()){
            mLayout = layoutObject.toArray();
            emit layoutChanged(mLayout);
        }

        auto settingsObject = rootObject.find("settings").value();

        if(!settingsObject.isNull() && settingsObject.isObject())
            emit deserializeConnection(settingsObject.toObject());
    }
}

void Persistance::persist(){

    QJsonObject documentObject;
    QJsonObject connections;

    emit serializeConnection(connections);

    documentObject.insert("layout", mLayout);
    documentObject.insert("settings", connections);

    if(isFilenameValid()){
        QFile layoutFile{mFilename.toLocalFile()};
        layoutFile.open(QIODevice::ReadWrite | QIODevice::Truncate);

        if(layoutFile.isOpen() && layoutFile.isWritable()){
            QJsonDocument document{documentObject};
            layoutFile.write(document.toJson());
        }
    }
}


Persistance::Persistable::~Persistable(){}
