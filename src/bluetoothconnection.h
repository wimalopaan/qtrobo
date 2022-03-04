#pragma once
#include "connection.h"
#include <QObject>
#include <QBluetoothServiceDiscoveryAgent>
#include <QBluetoothLocalDevice>
#include <QBluetoothSocket>
#include <QList>
#include <QBluetoothServiceInfo>

class BluetoothConnection : public Connection
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap services READ services NOTIFY servicesChanged)
    Q_PROPERTY(bool isDiscovering READ isDiscovering NOTIFY isDiscoveringChanged)
public:
    explicit BluetoothConnection(QObject *parent = nullptr);

    QByteArray read() override;

    void writeImpl(const QString &eventName) override;

    void connectImpl() override;
    void disconnectImpl() override;

    bool isConnected() const override;

    void parseDebug(/*DebugInfoDirection::DebugInfoDirection direction,*/ const QByteArray &data) override;

    QJsonObject serialize() override;
    void deserialize(const QJsonObject &data) override;

    Q_INVOKABLE void startDiscovery();
    Q_INVOKABLE void stopDiscovery();
    Q_INVOKABLE void setActivService(int serviceIndex);
    Q_INVOKABLE void addEntry();

signals:
    void servicesChanged(const QList<QBluetoothServiceInfo>&);
    void isDiscoveringChanged(bool);
    void error(QString error) const;

public slots:
    void serviceDiscovered(const QBluetoothServiceInfo&);
    void discoveryError(QBluetoothServiceDiscoveryAgent::Error);
    void socketError(QBluetoothSocket::SocketError);
    void socketStateChanged(QBluetoothSocket::SocketState);

protected:
    QVariantMap services() const;
    bool isDiscovering() const;

private:
    QBluetoothLocalDevice mLocalDevice;
    QBluetoothServiceDiscoveryAgent mServiceDiscoveryAgent;
    QBluetoothSocket mSocket;
    QList<QBluetoothServiceInfo> mServices;
    int mActiveServiceIndex;
};

