import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: __root
    height: 25
    property alias propertyValue: numValue.text
    property alias label: text1.placeholderText
    property alias propertyLabel: text1.text
    signal valueChanged(var value)

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

    Button {
        id: minusButton
        width: 20
        text: qsTr("-")
        anchors.right: numWrapper.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        onClicked: {
            numValue.decreaseValue()
        }
    }

    Button {
        id: plusButton
        width: 20
        text: qsTr("+")
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 8
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        onClicked: {
            numValue.increaseValue()
        }
    }

    Rectangle{
        id: numWrapper
        width: 30
        border.color: "#a6a6a6"
        border.width: 1
        anchors.right: plusButton.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 4
        anchors.bottomMargin: 4

        Text {
            id: numValue
            text : "0"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            function increaseValue () {
                var currentValue = parseInt(numValue.text);
                var newValue;
                if(currentValue >= 255){
                    newValue = 0;
                } else {
                    newValue = currentValue + 1;
                }
                __root.valueChanged(newValue);
            }
            function decreaseValue () {
                var currentValue = parseInt(numValue.text);
                var newValue;
                if(currentValue <= 0){
                    newValue = 255;
                } else {
                    newValue = currentValue - 1;
                }
                __root.valueChanged(newValue);
            }
        }

        MouseArea {
            x: -640
            y: 0
            anchors.fill: parent
            onWheel: {
                if(wheel.angleDelta.y>0)
                    numValue.increaseValue()
                if(wheel.angleDelta.y<0)
                    numValue.decreaseValue()
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#c0c0c0"}
}
##^##*/
