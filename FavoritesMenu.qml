import QtQuick 2.15
import SortFilterProxyModel 0.2

import "Logger.js" as Logger
// import "Components/GamesList"
import "Components/Generic"
import "Components/Delegates"

FocusScope {

    Item {
        id: favoritesMenuRoot
        focus: parent.focus

        //anchors.fill: parent
        width: parent.width
        height: parent.height

        Keys.onPressed: {
            if (api.keys.isFilters(event)) {
                event.accepted = true;
                Logger.debug("Favorties Menu:Filter button pressed");
                api.allGames.get(favoritesMenuProxyModel.mapToSource(favoritesGameList.currentIndex)).favorite = 
                    !api.allGames.get(favoritesMenuProxyModel.mapToSource(favoritesGameList.currentIndex)).favorite;
            }
        }

        SortFilterProxyModel {
            id: favoritesMenuProxyModel
            sourceModel: api.allGames
            filters: [
                ValueFilter {
                    enabled: true
                    roleName: "favorite"
                    value: true
                }
            ]
        }

        ItemList {
            id: favoritesGameList
            focus: parent.focus

            rows: themeSettings.itemListRows
            width: parent.width * (themeSettings.itemListWidth / 100)
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.08
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: parent.bottom

            model: favoritesMenuProxyModel
            delegate: gamesListDelegate.delegate
        }

        GamesListDelegate {
            id: gamesListDelegate
            rows: gamesListView.rows
        }


    }

}