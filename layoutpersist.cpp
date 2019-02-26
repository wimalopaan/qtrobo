#include "layoutpersist.h"
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFileInfo>
#include <QDebug>

LayoutPersist::LayoutPersist(QObject *parent) :
    QObject(parent)
{}

LayoutPersist::~LayoutPersist(){}

QJsonArray LayoutPersist::layout(){
    QFile layoutFile{mFilename.toLocalFile()};
    layoutFile.open(QIODevice::ReadOnly);

    if(layoutFile.isOpen() && layoutFile.isReadable()){
        return QJsonDocument::fromJson(layoutFile.readAll()).array();
    }

    return QJsonArray{};
}

void LayoutPersist::layout(const QJsonArray& layout){
    QFile layoutFile{mFilename.toLocalFile()};
    layoutFile.open(QIODevice::ReadWrite | QIODevice::Truncate);

    if(layoutFile.isOpen() && layoutFile.isWritable()){
        QJsonDocument document{layout};
        layoutFile.write(document.toJson());
    }
}

bool LayoutPersist::isFilenameValid() const{
    QFileInfo layoutFileInfo{mFilename.toLocalFile()};
    bool isValid = layoutFileInfo.exists() && layoutFileInfo.isFile() && layoutFileInfo.isWritable() && 0 == layoutFileInfo.suffix().compare("json", Qt::CaseInsensitive);

    qDebug() << "Is Valid: " << isValid;

    return isValid;
}

QUrl LayoutPersist::filename() const{
    return mFilename;
}
void LayoutPersist::filename(const QUrl& filename){
    mFilename = filename;
    emit filenameValidChanged(isFilenameValid());
}
