import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    id: root

    property string text: ""
    property alias font: counterText.font.family
    property alias fontSize: counterText.font.pixelSize

    Item {
        id: counterImage
        height: parent.height
        width: height

        visible: text != ""

        Rectangle {
            id: counterImageRect
            height: parent.height
            width: parent.width
            color: themeData.colorTheme[theme].primary
            visible: false
        }

        Image {
            id: counterImageMask
            height: parent.height
            width: height

            fillMode: Image.PreserveAspectFit

            source: "../../assets/retroarch-assets/file.png"
            asynchronous: true
            visible: false
        }

        OpacityMask {
            id: counterImageOpacityMask

            anchors.fill: parent
            source: counterImageRect
            maskSource: counterImageMask
        }
    }

    Text {
        id: counterText

        anchors {
            right: root.right
            rightMargin: parent.width * 0.05
            //left: counterImage.right
            verticalCenter: parent.verticalCenter
        }

        font.family: "HackRegular"
        font.pixelSize: parent.height * 0.7
        color: themeData.colorTheme[theme].primary

        text: root.text
    }
}
