#include "bluetoothconnection.h"

BluetoothConnection::BluetoothConnection(QObject *parent)
    :
      Connection(parent),
      mLocalDevice(this),
      mServiceDiscoveryAgent(this),
      mSocket(QBluetoothServiceInfo::Protocol::RfcommProtocol),
      mActiveServiceIndex(0)
{
    mServiceDiscoveryAgent.setUuidFilter(QBluetoothUuid::SerialPort);
    QObject::connect(&mSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    QObject::connect(&mSocket, SIGNAL(error(QBluetoothSocket::SocketError)), this, SLOT(socketError(QBluetoothSocket::SocketError)));
    QObject::connect(&mSocket, SIGNAL(stateChanged(QBluetoothSocket::SocketState)), this, SLOT(socketStateChanged(QBluetoothSocket::SocketState)));
    QObject::connect(&mServiceDiscoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)), this, SLOT(serviceDiscovered(QBluetoothServiceInfo)));
    QObject::connect(&mServiceDiscoveryAgent, SIGNAL(error(QBluetoothServiceDiscoveryAgent::Error)), this, SLOT(discoveryError(QBluetoothServiceDiscoveryAgent::Error)));
}

QByteArray BluetoothConnection::read(){
    parseDebug(DebugInfoDirection::DebugInfoDirection::In, QString{"Test"}.toLocal8Bit());
    return mSocket.readAll();
}

void BluetoothConnection::writeImpl(const QString &eventName){
    const char* dataBytes = eventName.toStdString().c_str();

    if(mParser.eventEnd() == '\0')
        mSocket.write(dataBytes, static_cast<qint64>(strlen(dataBytes)) + 1);
    else
        mSocket.write(dataBytes, static_cast<qint64>(strlen(dataBytes)));
}

void BluetoothConnection::connectImpl(){
    mServiceDiscoveryAgent.stop();
    emit isDiscoveringChanged(isDiscovering());
    if(mActiveServiceIndex < mServices.length())
        mSocket.connectToService(mServices.at(mActiveServiceIndex));
}

void BluetoothConnection::disconnectImpl(){
    mSocket.disconnectFromService();
}

bool BluetoothConnection::isConnected() const{
    return mSocket.state() == QBluetoothSocket::SocketState::ConnectedState;
}

void BluetoothConnection::parseDebug(DebugInfoDirection::DebugInfoDirection direction, const QByteArray &data){
    QString result;

    for(char byte : data){
        switch(byte){
            case '\n':
                result.append("\\n");
                break;
            case '\r':
                result.append("\\r");
                break;
            case '\0':
                result.append("\\0");
                break;
            default:
                result.append(byte);
        }
    }

    emit debugChanged(direction, result);
}

QJsonObject BluetoothConnection::serialize(){
    return QJsonObject{};
}

void BluetoothConnection::deserialize(const QJsonObject &data){
}

void BluetoothConnection::startDiscovery(){
    mLocalDevice.powerOn();
    mServiceDiscoveryAgent.start(QBluetoothServiceDiscoveryAgent::DiscoveryMode::FullDiscovery);
    emit isDiscoveringChanged(isDiscovering());
}

void BluetoothConnection::setActivService(int serviceIndex){
    mActiveServiceIndex = serviceIndex;
}

void BluetoothConnection::serviceDiscovered(const QBluetoothServiceInfo& service){
    mServices.push_back(service);
    emit servicesChanged(mServices);
}

QVariantMap BluetoothConnection::services() const{
    QVariantMap result;

    for(int i = 0; i < mServices.size(); ++i){
        auto service = mServices.at(i);
        QVariantMap entry;
        entry["name"] = service.device().name();
        entry["addr"] = service.device().address().toString();
        result[QString::number(i)] = entry;
    }

    return result;
}

void BluetoothConnection::addEntry(){
    QBluetoothServiceInfo info;
    QBluetoothDeviceInfo devInfo{QBluetoothUuid::SerialPort, "HC 05", 30};
    info.setDevice(devInfo);
    mServices.append(info);
    emit servicesChanged(mServices);
}

bool BluetoothConnection::isDiscovering() const{
    return mServiceDiscoveryAgent.isActive();
}

void BluetoothConnection::socketError(QBluetoothSocket::SocketError err){
    using Error = QBluetoothSocket::SocketError;
    switch(err){
        case Error::NetworkError:
            emit error("Network Error");
            break;
        case Error::OperationError:
            emit error("Operation Error");
            break;
        case Error::HostNotFoundError:
            emit error("Host Not Found Error");
            break;
        case Error::UnknownSocketError:
            emit error("Unknown Socket Error");
            break;
        case Error::ServiceNotFoundError:
            emit error("Service Not Found Error");
            break;
        case Error::RemoteHostClosedError:
            emit error("Remote Host Closed Error");
            break;
        case Error::UnsupportedProtocolError:
            emit error("Unsupported Protocol Error");
            break;
        default:
            break;
    };
}

void BluetoothConnection::discoveryError(QBluetoothServiceDiscoveryAgent::Error err){
    using Error = QBluetoothServiceDiscoveryAgent::Error;
    switch(err){
        case Error::UnknownError:
            emit error("Unknown Error");
            break;
        case Error::PoweredOffError:
            emit error("Powered Off Error");
            break;
        case Error::InputOutputError:
            emit error("IO Error");
            break;
        case Error::InvalidBluetoothAdapterError:
            emit error("Invalid Bluetooth Adapter Error");
            break;
        default:
            break;
    };
}

void BluetoothConnection::stopDiscovery(){
    mServiceDiscoveryAgent.stop();
    emit isDiscoveringChanged(mServiceDiscoveryAgent.isActive());
}

void BluetoothConnection::socketStateChanged(QBluetoothSocket::SocketState){
    emit connectionStateChanged(isConnected());
}
