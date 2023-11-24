import QtQuick 2.15

import "../../Logger.js" as Logger
import "../Delegates"

FocusScope {
    id: root

    property alias currentIndex: subMenuListView.currentIndex
    property alias currentItem: subMenuListView.currentItem
    property alias model: subMenuListView.model
    property alias listView: subMenuListView
    property alias columns: subMenuListView.columns

    property alias textName: subMenuDelegate.textName

    function moveIndex(index) {
        subMenuListView.currentIndex = index;
        subMenuListView.positionViewAtIndex(index, ListView.SnapPosition);
    }

    ListView {
        id: subMenuListView

        //focus: subMenu.focus

        //width: parent.width * 0.54
        // width: parent.width * 0.54
        // height: parent.height * 0.06

        // anchors.left: parent.left
        // anchors.leftMargin: parent.width * 0.06

        anchors.fill: parent

        property int fontSize: 24
        property int columns: 4

        onColumnsChanged: {
            var col = themeSettings.subMenuColumns;
            Logger.debug("SubMenu:columnsChanged:columns:" + columns);
            if (subMenuListView.count <= col || col == 0) {
                subMenuListView.columns = subMenuListView.count;
            }
            else {
                // Keep max columns to 4 for top menu
                subMenuListView.columns = col;
            }

            Logger.debug("SubMenu:columnsChanged:" + columns);

        }

        model: []
        delegate: subMenuDelegate.delegate

        orientation: ListView.Horizontal

        interactive: false
        clip: true

        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: width / columns
        preferredHighlightEnd: (width / columns) * 2
        highlightMoveDuration: 0

        // Keys.onLeftPressed: subMenuListView.decrementCurrentIndex
        // Keys.onRightPressed: subMenuListView.incrementCurrentIndex


        TextMetrics {
            id: subMenuListFont
            font.family: "HackRegular"
            font.bold: true
            font.capitalization: Font.AllUppercase
        }

        function resizeFont() {
            const collectionNames = []
            for(var i=0; i < subMenuListView.model.count; ++i) {
                collectionNames.push(subMenuListView.model.get(i))
            }
            Logger.info("SubMenu:resizeFont:list:typeof:" + (typeof collectionNames))
            fontSize = utils.calculateFontSizeModel(subMenuListFont.font, 
                (subMenuListView.width / subMenuListView.columns) * 0.8,
                subMenuListView.height, 
                collectionNames.map((x) => x[subMenuDelegate.textName])
                //model.map((x) => x[subMenuDelegate.textName])
                // model.map((x) => x.name)
                // model.toVarArray().map((x) => x.name)
            );
        }

        onHeightChanged: resizeFont()
        onWidthChanged: resizeFont()
        onCountChanged: resizeFont()

        Component.onCompleted: {
            // fontSize = utils.calculateFontSizeModel(subMenuListFont.font, 
            //     (subMenuListView.width / subMenuListView.columns) * 0.8,
            //     subMenuListView.height, 
            //     model.toVarArray().map((x) => x.name)
            // )
            columns = themeSettings.subMenuColumns;
            resizeFont()
            // The position for the middle elements caused it to be at the beginning
            // This is a workaround to fix the view
            if (currentIndex > 0) { positionViewAtIndex(currentIndex - 1, ListView.SnapPosition) }
            else { positionViewAtIndex(currentIndex, ListView.SnapPosition) }
        }

        onCurrentIndexChanged: {
            Logger.info("SubMenu:subMenuListView:currentIndexChanged:" + currentIndex)
        }
    }

    SubMenuDelegate {
        id: subMenuDelegate
        textName: "name"
    }

    // Component {
    //     id: subMenuDelegate

    //     // property alias textName: subMenuTextRect.textName

    //     Item {
    //         id: subMenuTextRect

    //         property string textName: "name"


    //         width: ListView.view.width / ListView.view.columns
    //         height: ListView.view.height

    //         Text {
    //             id: subMenuText
    //             text: modelData[textName]

    //             font.family: "HackRegular"
    //             font.pixelSize: subMenuListView.fontSize
    //             font.bold: false
    //             color: subMenuTextRect.ListView.isCurrentItem ? themeData.colorTheme[theme].primary : themeData.colorTheme[theme].secondary
    //             //color: themeData.colorTheme[theme].primary
    //             font.capitalization: Font.AllUppercase

    //             anchors {
    //                 // bottom: parent.bottom
    //                 // horizontalCenter: parent.horizontalCenter
    //                 centerIn: parent
    //             }

    //         }

    //     }

    // }


}
