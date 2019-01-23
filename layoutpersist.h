#pragma once
#include <QObject>
#include <QJsonArray>
#include <QUrl>

class LayoutPersist : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonArray layout READ layout WRITE layout)
    Q_PROPERTY(QUrl filename MEMBER mFilename)

public:
    LayoutPersist(QObject *parent = nullptr);
    ~LayoutPersist();

    QJsonArray layout();
    void layout(const QJsonArray& layout);

private:
    QUrl mFilename;
};
