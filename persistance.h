#pragma once
#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QUrl>

class Persistance : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonArray layout MEMBER mLayout NOTIFY layoutChanged)
    Q_PROPERTY(QUrl filename READ filename WRITE filename)
    Q_PROPERTY(bool isFilenameValid READ isFilenameValid NOTIFY filenameValidChanged)

public:
    class Persistable{
    public:

        virtual ~Persistable();
        virtual QJsonObject serialize() = 0;
        virtual void deserialize(const QJsonObject &data) = 0;
    };

    Persistance(QObject *parent = nullptr);
    ~Persistance();

    Q_INVOKABLE void persist();
    Q_INVOKABLE void restore();

    QUrl filename() const;
    void filename(const QUrl& filename);

    bool isFilenameValid() const;

signals:
    void layoutChanged(const QJsonArray &layout);
    void filenameValidChanged(bool isFilenameValid);
    void serializeConnection(QJsonObject &data);
    void deserializeConnection(QJsonObject data);

private:
    QUrl mFilename;
    QJsonArray mLayout;
};
