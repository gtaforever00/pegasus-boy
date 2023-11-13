import QtQuick 2.15

FocusScope {

    property alias model: settingsOptionListView.model
    property alias currentIndex: settingsOptionListView.currentIndex

    ListView {
        id: settingsOptionListView
        focus: parent.focus

        property int rows: 4

        width: parent.width
        height: parent.height

        orientation: ListView.Vertical

        model: []
        clip: true
        delegate: settingsOptionListDelegate

    }

    Component {
        id: settingsOptionListDelegate

        Rectangle {
            id: settingsOptionRect
            width: ListView.view.width
            height: ListView.view.height / ListView.view.rows

            color: ListView.isCurrentItem ? themeData.colorTheme[theme].dark : themeData.colorTheme[theme].light

            Text {
                id: settingsOptionText

                width: parent.width

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: parent.width * 0.02
                }

                font.family: "HackRegular"
                font.pixelSize: parent.height * 0.4

                color: settingsOptionListView.ListView.isCurrentItem ? themeData.colorTheme[theme].primary : themeData.colorTheme[theme].secondary

                text: modelData
            }
        }

    }
}