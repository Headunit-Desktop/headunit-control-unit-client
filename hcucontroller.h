#ifndef HCUCONTROLLER_H
#define HCUCONTROLLER_H

#include <QObject>
#include <QThread>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QStringList>
#include <QDebug>
#include <QByteArray>
#include <QQmlPropertyMap>
#include "HCUcrl/HUDSerial/HUDSerial.h"


class HCUController : public QObject, PlatformCallbacks
{
    Q_OBJECT
    Q_PROPERTY(QStringList ports READ getPorts NOTIFY portsUpdated)
    Q_PROPERTY(bool connected READ getConnected NOTIFY connectedUpdated)
    Q_PROPERTY(QVariantMap ClimateControlFrame READ getClimateControlFrame NOTIFY ClimateControlFrameUpdated)
    Q_PROPERTY(QVariantList CustomCommandBits READ getCustomCommandBits NOTIFY CustomCommandFrameUpdated)
    Q_PROPERTY(QVariantList CustomCommandBytes READ getCustomCommandByes NOTIFY CustomCommandFrameUpdated)
public:
    explicit HCUController(QObject *parent = nullptr);

    static void customCommandCallback(CustomCommandFrame commandFrame);
    static void climateControlCallback(ClimateControlCommandFrame commandFrame);
    static void buttonInputCallback(Keys key);
    static void sendMessageCallback(uint8_t receivedByte);
    void receiveCustomCommand(CustomCommandFrame commandFrame);
    void receiveClimateControl(ClimateControlCommandFrame commandFrame);
    void receiveButtonInputCallback(Keys key);
    void receiveSendMessage(uint8_t receivedByte);

    void ClimateControlCallback(ClimateControlCommandFrame) override;
    void CustomCommandCallback(CustomCommandFrame) override;
    void ButtonInputCommandCallback(Keys) override;
    void SendMessageCallback(uint8_t) override;
    void PrintString(char * message) override;
public slots:
    void setParameter(QString parameter, bool value);
    void setZoneParameter(QString zone, QString parameter, QVariant value);

private:
    QSerialPort m_serial;
    QStringList m_ports;
    bool m_connected;
    void updatePorts();
    HUDSerial m_hudSerial;
    CustomCommandFrame m_commandFrame;
    ClimateControlCommandFrame m_ccCommandFrame;

    QVariantMap m_climateControlFrame;
    QVariantList m_customCommandFrameBits;
    QVariantList m_customCommandFrameBytes;

    QStringList getPorts() {
        return m_ports;
    }
    bool getConnected(){
        return m_connected;
    }
    QVariantMap getClimateControlFrame(){
        return m_climateControlFrame;
    }
    QVariantList getCustomCommandBits(){
        return m_customCommandFrameBits;
    }
    QVariantList getCustomCommandByes(){
        return m_customCommandFrameBytes;
    }

signals:
    void portsUpdated();
    void connectedUpdated();
    void ClimateControlFrameUpdated();
    void CustomCommandFrameUpdated();
    void logLineReceived(QString logLine);
public slots:
    void connectSerial(QString port, QString baud);
    void disconnectSerial();
    void setCustomCommandBit(int bitNumber, bool value);
    void setCustomCommandByte(int byteNumber, int value);

    void handleReadyRead();
    void handleError(QSerialPort::SerialPortError error);
};

#endif // HCUCONTROLLER_H
