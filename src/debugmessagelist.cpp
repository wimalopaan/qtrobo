#include "debugmessagelist.h"
#include <iostream>

DebugMessageList::DebugMessageList(QObject *parent) : QObject(parent)
{

}

QVector<DebugItem> DebugMessageList::items() const
{
    return mItems;
}



bool DebugMessageList::shouldRecord()const{
    return mRecording;
}

void DebugMessageList::invertRecording(){
    mRecording = !mRecording;
}

void DebugMessageList::clear(){
   emit clearList();
}

void DebugMessageList::deleteMessages(){
   mItems.clear();
}

bool DebugMessageList::setItemAt(int index, const DebugItem &item)
{
    if (index < 0 || index >= mItems.size())
        return false;

    mItems[index] = item;
    return true;
}

void DebugMessageList::appendItem(const QString& dmessage)
{

    if (mRecording){
        emit preItemAppended();

        DebugItem item;
        item.message = dmessage;
        mItems.append(item);

        emit postItemAppended();
    }

}
