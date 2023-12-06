import QtQuick 2.15

Item {
    id: root

    property alias contentWidth: timeText.contentWidth

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            var date = new Date();
            var options = {
                hour: "numeric",
                minute: "numeric",
            }
            timeText.text = date.toLocaleTimeString('en-US')
        }
    }

    Text {
        id: timeText
        
        font.family: "HackRegular"
        font.pixelSize: parent.height * 0.7
        color: themeData.colorTheme[theme].primary

        text: { new Date().toLocaleTimeString('en-US') }
    }
}
