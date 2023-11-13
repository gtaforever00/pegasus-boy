import QtQuick 2.15

FocusScope {

    property alias model: settingsListView.model
    property alias currentIndex: settingsListView.currentIndex
    property alias currentItem: settingsListView.currentItem

    ListView {
        id: settingsListView
        focus: parent.focus

        property int rows: 9

        width: parent.width
        height: parent.height

        orientation: ListView.Vertical

        model: []
        clip: true
        delegate: settingsListDelegate
    }

    Component {
        id: settingsListDelegate
        
        Rectangle {
            id: settingsListRect
            width: ListView.view.width
            height: ListView.view.height / ListView.view.rows


            color: ListView.isCurrentItem ? themeData.colorTheme[theme].primary : themeData.colorTheme[theme].background

            Text {
                id: settingsNameText

                width: parent.width

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: (font.pixelSize * 0.7) + parent.width * 0.04
                }


                font.family: "HackRegular"
                font.pixelSize: parent.height * 0.4

                elide: Text.ElideRight
                color: settingsListRect.ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].primary

                text: modelData.name
            }
        }

    }
}