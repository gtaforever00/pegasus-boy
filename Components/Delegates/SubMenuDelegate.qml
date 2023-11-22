import QtQuick 2.15
import "../../Logger.js" as Logger

Item {

    property alias delegate: subMenuDelegate
    property string textName: "name"

    Component {
        id: subMenuDelegate

        // property alias textName: subMenuTextRect.textName

        Item {
            id: subMenuTextRect



            width: ListView.view.width / ListView.view.columns
            height: ListView.view.height

            Text {
                id: subMenuText
                text: model[textName]

                font.family: "HackRegular"
                font.pixelSize: subMenuListView.fontSize
                font.bold: false
                color: subMenuTextRect.ListView.isCurrentItem ? themeData.colorTheme[theme].primary : themeData.colorTheme[theme].secondary
                //color: themeData.colorTheme[theme].primary
                font.capitalization: Font.AllUppercase
                opacity: {
                    if (Math.abs(subMenuTextRect.ListView.view.currentIndex - index) > 1) {
                        return 0.4;
                    }
                    return 1;
                }

                anchors {
                    // bottom: parent.bottom
                    // horizontalCenter: parent.horizontalCenter
                    centerIn: parent
                }

            }

        }

    }

}
