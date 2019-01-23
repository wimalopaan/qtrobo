#include "layoutpersist.h"
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QJsonArray>

LayoutPersist::LayoutPersist(QObject *parent) :
    QObject(parent)
{
}

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
    layoutFile.open(QIODevice::ReadWrite);

    if(layoutFile.isOpen() && layoutFile.isWritable()){
        QJsonDocument document{layout};
        layoutFile.write(document.toJson());
    }
}
