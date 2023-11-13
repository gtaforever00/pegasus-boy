import QtQuick 2.15
import SortFilterProxyModel 0.2

import "Logger.js" as Logger

import "Components/Generic"
import "Components/Delegates"


FocusScope {

    Item {
        id: lastPlayedMenuRoot

        focus: parent.focus

        width: parent.width
        height: parent.height

        SortFilterProxyModel {
            id: lastPlayedProxyModel
            sourceModel: api.allGames
            filters: [
                ExpressionFilter {
                    enabled: true
                    expression: {
                        var dateOffset = (24 * 60 * 60 * 1000) * themeSettings.lastPlayedDays;
                        var myDate = new Date();
                        myDate.setTime(myDate.getTime() - dateOffset);
                        //Logger.info(lastPlayed);
                        return (modelData.lastPlayed > myDate ? true : false);
                    }
                }
            ]
        }


        ItemList {
            id: gamesListView
            focus: parent.focus

            rows: themeSettings.itemListRows
            width: parent.width * (themeSettings.itemListWidth / 100)
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.08
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.02
            // anchors.right: parent.right
            anchors.bottom: parent.bottom


            model: lastPlayedProxyModel
            delegate: gamesListDelegate.delegate
        }

        GamesListDelegate {
            id: gamesListDelegate
            rows: gamesListView.rows
        }


    }
}