import QtQuick 2.15

Item {

    required property int rows

    property alias delegate: gamesListDelegate

    property string textName: "title"

    Component {
        id: gamesListDelegate


        Rectangle {
            id: gamesListRect

            property int rows: 1

            width: ListView.view.width
            height: ListView.view.height / ListView.view.rows

            color: {
                if (activeFocus) { return ListView.isCurrentItem ? themeData.colorTheme[theme].primary : themeData.colorTheme[theme].background };
                return ListView.isCurrentItem ? themeData.colorTheme[theme].light : themeData.colorTheme[theme].background;
            }

            Rectangle {
                id: gamesListFavorite

                width: height
                height: gamesListText.font.pixelSize * 0.7

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: parent.width * 0.02
                }

                color: {
                    if (activeFocus) { return gamesListRect.ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].primary };
                    gamesListRect.ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].light;
                }
                visible: model.favorite !== undefined && model.favorite
                //visible: modelData.favorite !== undefined && modelData.favorite
            }

            Text {
                id: gamesListText

                width: parent.width
                //height: parent.height

                // anchors.top: parent.top
                //anchors.left: parent.left
                anchors.left: gamesListFavorite.right
                // anchors.right: parent.right
                // anchors.bottom: parent.bottom
                anchors.leftMargin: parent.width * 0.02
                anchors.verticalCenter: parent.verticalCenter

                font.family: "HackRegular"
                // fontSizeMode: Text.HorizontalFit
                // minimumPixelSize: 8
                // font.pixelSize: 72
                font.pixelSize: parent.height * (gamesListRect.ListView.isCurrentItem ? 0.42 : 0.4)
                font.bold: gamesListRect.ListView.isCurrentItem ? true : false

                elide: Text.ElideRight
                color: gamesListRect.ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].primary


                text: model[textName]
                //text: modelData[textName]
            }
            
        }
    }
}
