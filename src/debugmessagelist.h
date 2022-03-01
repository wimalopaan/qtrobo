#ifndef DEBUGMESSAGELIST_H
#define DEBUGMESSAGELIST_H

#include <QObject>
#include <QVector>

struct DebugItem
{
    QString message;
};


class DebugMessageList : public QObject
{
    Q_OBJECT
public:
    explicit DebugMessageList(QObject *parent = nullptr);

    QVector<DebugItem> items() const;

    bool setItemAt(int index, const DebugItem& item);
    Q_INVOKABLE bool shouldRecord() const;
    Q_INVOKABLE void invertRecording();
    Q_INVOKABLE void clear();
    void deleteMessages();


signals:
    void preItemAppended();
    void postItemAppended();
    void clearList();




public slots:
    void appendItem(const QString& message);


private:
    QVector<DebugItem> mItems;
    bool mRecording = false;

};

#endif // DEBUGMESSAGELIST_H
