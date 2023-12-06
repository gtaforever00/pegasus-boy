
import QtQuick 2.15

Item {
    id: root

    required property color buttonColor
    required property color textColor
    property string text: ""

    Rectangle {
        id: squareButton

        height: parent.height
        width: height * 1.5

        color: root.buttonColor
        radius: 3

        Text {
            id: squareButtonText

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
