#include "debugmessagemodel.h"
#include "debugmessagelist.h"
#include <iostream>
#include <QDebug>

DebugMessageModel::DebugMessageModel(QObject *parent)
    : QAbstractListModel(parent),
      mList{nullptr}
{
}

int DebugMessageModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()|| !mList)
        return 0;


    return mList->items().size();
}

QVariant DebugMessageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()|| !mList)
        return QVariant();

    const DebugItem item = mList->items().at(index.row());

    return QVariant(item.message);
}

bool DebugMessageModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!mList)
        return false;

    DebugItem item = mList->items().at(index.row());

    item.message = value.toString();

    if (mList->setItemAt(index.row(),item)) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags DebugMessageModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> DebugMessageModel::roleNames() const
{
    QHash<int,QByteArray> names;
    names[DebugMessage] = "message";
    return names;

}

DebugMessageList *DebugMessageModel::list() const
{
    return mList;
};
void DebugMessageModel::setList(DebugMessageList *list){
    beginResetModel();
    if(mList)
        mList->disconnect(this);
    mList = list;

    if (mList){
        connect(mList, &DebugMessageList::preItemAppended,this,[=](){
            const int index = mList->items().size();
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(mList, &DebugMessageList::postItemAppended,this,[=](){
            endInsertRows();
        });
        connect(mList, &DebugMessageList::clearList,this,[=](){
            beginRemoveRows(QModelIndex(), 0, mList->items().size());
            endRemoveRows();
            mList->deleteMessages();

            qDebug() << mList->items().size();

        });

    }

    endResetModel();

};
