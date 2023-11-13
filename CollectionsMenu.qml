import QtQuick 2.15
import QtGraphicalEffects 1.12

import "Logger.js" as Logger
import "Components/Delegates"
import "Components/Generic"
import "Components/SubMenu"
import "Components/GamesMedia"

FocusScope {

    Item {
        id: collectionsMenuRoot
        width: parent.width
        height: parent.height

        // focus: parent.focus

        property alias collectionsMenuListView: collectionsMenuListView
        property alias gamesListView: gamesListView

        property var currentCollection: {
            return themeData.collectionsModel[collectionsMenuListView.currentIndex]
        }

        property var currentGame: { 
            return themeData.collectionsModel[collectionsMenuListView.currentIndex].games.get(gamesListView.currentIndex)
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Left) {
                event.accepted = true;
                collectionsMenuListView.listView.decrementCurrentIndex();
                return;
            }
            
            if (event.key == Qt.Key_Right) {
                event.accepted = true;
                collectionsMenuListView.listView.incrementCurrentIndex();
                return;
            }

            // TODO: Move to on release key event
            if (api.keys.isFilters(event)) {
                event.accepted = true;
                themeData.collectionsModel[collectionsMenuListView.currentIndex].games.get(gamesListView.currentIndex).favorite = 
                    !themeData.collectionsModel[collectionsMenuListView.currentIndex].games.get(gamesListView.currentIndex).favorite;
                return;
            }

            if (api.keys.isAccept(event)) {
                event.accepted = true;
                currentGame.launch();
                return;
            }

            if (api.keys.isPageUp(event)) {
                event.accepted = true;
                var count = themeData.collectionsModel[collectionsMenuListView.currentIndex].games.count;
                var index = gamesListView.currentIndex - 10;
                if (index < 0) {index = 0;}
                gamesListView.currentIndex = index;
                return;
            }

            if (api.keys.isPageDown(event)) {
                event.accepted = true;
                var count = themeData.collectionsModel[collectionsMenuListView.currentIndex].games.count;
                var index = gamesListView.currentIndex + 10;
                if (index > count) {index = count - 1;}
                gamesListView.currentIndex = index;
                return;
            }
        }


        SubMenu {
            id: collectionsMenuListView

            focus: false

            width: parent.width * (themeSettings.subMenuWidth / 100)
            height: parent.height * (themeSettings.subMenuHeight / 100)

            columns: themeSettings.subMenuColumns

            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.06

            model: themeData.collectionsModel

            textName: {
                if (themeSettings.collectionShortNames) { return "shortName"};
                return "name";
            }
            
        }


        ItemList {
            id: gamesListView

            focus: true
            rows: themeSettings.itemListRows

            anchors.top: collectionsMenuListView.bottom
            anchors.topMargin: parent.height * 0.02
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: footer.top

            width: parent.width * (themeSettings.itemListWidth / 100)

            model: themeData.collectionsModel[collectionsMenuListView.currentIndex].games
            delegate: gamesListDelegate.delegate

        }

        GamesListDelegate {
            id: gamesListDelegate
            rows: gamesListView.rows
        }

        Footer {
            id: footer

            height: parent.height * 0.1
            width: parent.width
            anchors.bottom: parent.bottom
            focus: false

            footerLeftText: (gamesListView.currentIndex + 1) + "/" + themeData.collectionsModel[collectionsMenuListView.currentIndex].games.count

        }


        GamesMedia01 {
            id: gamesMediaRoot

            anchors.top: collectionsMenuListView.bottom
            anchors.topMargin: parent.height * 0.02
            anchors.right: parent.right
            anchors.left: gamesListView.right
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: parent.bottom

            currentGame: themeData.collectionsModel[collectionsMenuListView.currentIndex].games.get(gamesListView.currentIndex)
        }

    }
}