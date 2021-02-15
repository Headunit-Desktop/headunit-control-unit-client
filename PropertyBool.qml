import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: __root
    height: 20
    property alias propertyEnabled: control.checked
    property alias label: text1.placeholderText
    property alias propertyLabel: text1.text
    signal switchClicked(var value)

    TextField {
        id:text1
        width: 150
        height: 17
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        font.pixelSize: 12
        padding: 0
        anchors.leftMargin: 8
    }

    Switch {
        id: control
        //        checked: __root.propertyEnabled
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        autoExclusive: false
        anchors.rightMargin: 8
        padding: 0
        indicator: Rectangle {
            implicitWidth: 48
            implicitHeight: 20
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: 13
            color: control.checked ? "#17a81a" : "#ffffff"
            border.color: control.checked ? "#17a81a" : "#cccccc"

            Rectangle {
                x: control.checked ? parent.width - width : 0
                width: 20
                height: 20
                radius: 10
                color: control.down ? "#cccccc" : "#ffffff"
                border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
            }
        }
    }
    MouseArea {
        height: 20
        anchors.fill: control
        preventStealing: true
        onClicked: {
            __root.switchClicked(!control.checked)
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#c0c0c0"}
}
##^##*/
