#ifndef DEBUGMESSAGEMODEL_H
#define DEBUGMESSAGEMODEL_H

#include <QAbstractListModel>

class DebugMessageList;

class DebugMessageModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(DebugMessageList *list READ list WRITE setList)

public:
    explicit DebugMessageModel(QObject *parent = nullptr);

    enum{
        DebugMessage
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index ,int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    virtual QHash<int,QByteArray> roleNames() const override;

    DebugMessageList *list() const;
    void setList(DebugMessageList *list);

private:
    DebugMessageList *mList;
};

#endif // DEBUGMESSAGEMODEL_H
