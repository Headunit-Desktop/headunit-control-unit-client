import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import Qt.labs.settings 1.0

Window {
    id: window
    visible: true
    width: 1100
    height: 800
    title: "HCU Console"

    Item {
        id: element4
        anchors.rightMargin: 12
        anchors.leftMargin: 12
        anchors.bottomMargin: 12
        anchors.topMargin: 12
        anchors.fill: parent


        Item {
            id: connectionWrapper
            height: 40
            anchors.left: parent.left
            anchors.right: parent.right

            Button {
                id: connect
                text: HCUConnection.connected? qsTr("Disconnect") : qsTr("Connect")
                anchors.left: speed.right
                anchors.leftMargin: 6
                onClicked: {
                    if(HCUConnection.connected) {
                        HCUConnection.disconnectSerial()
                    } else {
                        HCUConnection.connectSerial(port.currentText, speed.currentText)
                    }
                }
            }

            ComboBox {
                id: speed
                anchors.left: port.right
                enabled: !HCUConnection.connected
                anchors.leftMargin: 6
                currentIndex : model.indexOf("1000000")
                model: ["110","150","300","1200","2400","4800","9600","19200","38400","57600","115200","230400","460800","921600", "1000000"]
            }

            ComboBox {
                id: port
                model:HCUConnection.ports
                enabled: !HCUConnection.connected
            }
        }

        RowLayout {
            id: rowLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: connectionWrapper.bottom
            anchors.bottom: parent.bottom
            ColumnLayout {
                Layout.minimumWidth: 500
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.rowSpan: 2
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    text: "HVAC Zone Control"
                    font.bold: true
                    font.pointSize: 12
                    Layout.fillWidth: true
                    height: 30
                }
                GridLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 100
                    Layout.minimumWidth: 200
                    columns: 2
                    rows: 2
                    Repeater{
                        model: ["FrontLeft", "FrontRight", "RearLeft", "RearRight"]
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            property var outerModelData: modelData

                            Text {
                                text: modelData
                                Layout.fillWidth: true
                                height: 30
                                font.pointSize: 10
                                font.bold: true
                            }

                            Repeater{
                                model: ["DirUp", "DirCenter", "DirDown", "DirAuto"]
                                PropertyBool {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: false
                                    label : modelData
                                    onSwitchClicked: HCUConnection.setZoneParameter(outerModelData,modelData,value)
                                    propertyEnabled: HCUConnection.ClimateControlFrame[outerModelData][modelData]
                                }
                            }
                            PropertyByte {
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                label : "Fan"
                                onValueChanged: HCUConnection.setZoneParameter(outerModelData,"Fan",value)
                                propertyValue: HCUConnection.ClimateControlFrame[outerModelData]["Fan"]
                            }
                            PropertyByte {
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                label : "Temperature"
                                onValueChanged: HCUConnection.setZoneParameter(outerModelData,"Temperature",value)
                                propertyValue: HCUConnection.ClimateControlFrame[outerModelData]["Temperature"]
                            }
                            PropertyByte {
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                label : "SeatHeating"
                                onValueChanged: HCUConnection.setZoneParameter(outerModelData,"SeatHeating",value)
                                propertyValue: HCUConnection.ClimateControlFrame[outerModelData]["SeatHeating"]
                            }
                        }
                    }
                }


                Text {
                    text: "HVAC Parameter Bits"
                    font.bold: true
                    font.pointSize: 12
                    Layout.fillWidth: true
                    height: 30
                }

                Item {
                    Layout.minimumWidth: 100
                    Layout.minimumHeight: 100
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    ColumnLayout {
                        anchors.fill: parent
                        Repeater{
                            model: ["TempSelectLeft", "TempSelectRight", "FanSelectLeft", "FanSelectRight", "ProgAuto", "ProgAutoFanFront",
                                    "ProgAutoFanRear", "ProgWindscreen", "Recirculate", "RearDefrost", "AC"]
                            PropertyBool {
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                label : modelData
                                onSwitchClicked: HCUConnection.setParameter(modelData, value)
                                propertyEnabled: HCUConnection.ClimateControlFrame[modelData]
                            }
                        }
                    }
                }

            }
            Item {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.minimumWidth: 250
                Layout.minimumHeight: 100
                Layout.fillHeight: false
                Layout.fillWidth: true
                ColumnLayout {
                    id: columnLayout1
                    anchors.fill: parent
                    Text {
                        text: "Custom Command Bits"
                        font.bold: true
                        font.pointSize: 12
                        Layout.fillWidth: true
                        height: 30
                    }
                    Repeater{
                        model: HCUConnection.CustomCommandBits.length
                        PropertyBool {
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                            label : "Custom Bit " + index
                            onSwitchClicked: HCUConnection.setCustomCommandBit(index, value)
                            propertyEnabled: HCUConnection.CustomCommandBits[index]
                        }
                    }
                    Text {
                        text: "Custom Command Bytes"
                        font.pointSize: 12
                        font.bold: true
                        Layout.fillWidth: true
                        height: 30
                    }
                    Repeater {
                        model : HCUConnection.CustomCommandBytes.length
                        PropertyByte {
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                            label : "Custom Byte " + index
                            onValueChanged: HCUConnection.setCustomCommandByte(index,value)
                            propertyValue: HCUConnection.CustomCommandBytes[index]
                        }
                    }
                }
            }

            Frame {
                id: frame
                Layout.minimumWidth: 250
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                Flickable {
                    id: scrollView
                    anchors.fill: parent
                    contentHeight: actionLog.height
                    ScrollBar.vertical: ScrollBar {}
                    TextArea.flickable: TextArea {
                        id: actionLog
                        text: qsTr("")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        font.pixelSize: 12
                        activeFocusOnPress: false
                        readOnly: true
                        onTextChanged: {
                        }
                    }
                }
            }
        }


    }
    Connections {
        target: HCUConnection
        function onLogLineReceived(logLine)  {
            actionLog.append(logLine)
        }
    }
}


/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}
}
##^##*/
