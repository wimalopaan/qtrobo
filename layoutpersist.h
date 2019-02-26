#pragma once
#include <QObject>
#include <QJsonArray>
#include <QUrl>

class LayoutPersist : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonArray layout READ layout WRITE layout)
    Q_PROPERTY(QUrl filename READ filename WRITE filename)
    Q_PROPERTY(bool isFilenameValid READ isFilenameValid NOTIFY filenameValidChanged)

public:
    LayoutPersist(QObject *parent = nullptr);
    ~LayoutPersist();

    QJsonArray layout();
    void layout(const QJsonArray& layout);

    QUrl filename() const;
    void filename(const QUrl& filename);

    bool isFilenameValid() const;

signals:
    void filenameValidChanged(bool isFilenameValid);

private:
    QUrl mFilename;
};
