#include "pipeconnection.h"

PipeConnection::PipeConnection(QObject *parent) : Connection(parent)
{
    QObject::connect(&mInputPipe, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
}

QByteArray PipeConnection::read(){
    return mInputPipe.readAll();
}

void PipeConnection::writeImpl(const QString &eventName){
    const char* dataBytes = eventName.toStdString().c_str();

    //parseDebug("Out", QByteArray{dataBytes});

    if(mParser.eventEnd() == '\0')
        mOutputPipe.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
    else
        mOutputPipe.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
}

void PipeConnection::connect(const QVariantMap &preferences){
    mInputPipe.setFileName("fifoIn");
    mInputPipe.open(QIODevice::ReadOnly);
    mOutputPipe.setFileName("fifoOut");
    mOutputPipe.open(QIODevice::WriteOnly);

}

void PipeConnection::disconnect(){

}

bool PipeConnection::isConnected() const{

    return mInputPipe.isOpen() && mOutputPipe.isOpen();
}
