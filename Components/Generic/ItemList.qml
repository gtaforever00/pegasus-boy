import QtQuick 2.15

import "../../Logger.js" as Logger
import "../Scrollbar"

FocusScope {
    id: root
    property alias currentIndex: itemListView.currentIndex
    property alias currentItem: itemListView.currentItem
    property alias model: itemListView.model
    property alias delegate: itemListView.delegate
    property alias rows: itemListView.rows
    //required property var model

    function moveIndex(index) {
        Logger.info("ItemList:moveIndex:" + index)
        itemListView.currentIndex = index;
        itemListView.positionViewAtIndex(index, ListView.SnapPosition);
    }
//    onIndexChanged: (index) => itemListView.positionViewAtIndex(index, ListView.SnapPostiion)

    Scrollbar {
        id: scrollbar
        visibleArea: itemListView.visibleArea

        anchors {
            left: parent.left
            right: itemListView.left
            rightMargin: 3
            top: parent.top
            bottom: parent.bottom
        }

    }
    
    ListView {
        id: itemListView

        focus: true
        property int rows: 9

        //anchors.fill: parent
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: parent.width * 0.04
            right: parent.right
        }

        orientation: ListView.Vertical

        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: (height / 2) - (height / rows)
        preferredHighlightEnd: (height / 2) + (height / rows)
        highlightMoveDuration: 0

        model: []
        clip: true

        Component.onCompleted: positionViewAtIndex(currentIndex, ListView.SnapPosition)

        onCurrentIndexChanged: {
            Logger.info("ItemList:itemListView:indexchanged:" + currentIndex)
        }

        //delegate: gamesListDelegate

    }

}

