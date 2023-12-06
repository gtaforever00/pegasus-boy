import QtQuick 2.15

Item {
    id: root

    required property color buttonColor
    required property color textColor
    property string text: ""

    Rectangle {
        id: circleButton

        height: parent.height
        width: height

        color: root.buttonColor
        radius: 180

        Text {
            id: circleButtonText

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            font.family: "HackRegular"
            font.pixelSize: parent.height * 0.8
            font.bold: true
            color: root.textColor

            text: root.text
        }
    }
}
