import QtQuick 2.15
import SortFilterProxyModel 0.2
import QtGraphicalEffects 1.12

import "Logger.js" as Logger
import "Components/Delegates"
import "Components/Generic"
import "Components/SubMenu"
import "Components/GamesMedia"

FocusScope {

    property alias gamesListModel: collectionsMenuRoot.gamesListModel
    property alias subMenuModel: collectionsMenuRoot.subMenuModel
    property alias subMenuEnable: collectionsMenuRoot.subMenuEnable

    property alias collectionsMenuListView: collectionsMenuRoot.collectionsMenuListView
    property alias subMenuIndex: collectionsMenuRoot.subMenuIndex

    property alias menuName: collectionsMenuRoot.menuName

    property alias filterOnlyFavorites: collectionsMenuRoot.filterOnlyFavorites
    property alias filterByDate: collectionsMenuRoot.filterByDate
    
    property alias currentCollection: collectionsMenuRoot.currentCollection

    Item {
        id: collectionsMenuRoot
        width: parent.width
        height: parent.height

        property alias collectionsMenuListView: collectionsMenuListView
        property alias gamesListView: gamesListView
        
        required property string menuName

        required property bool subMenuEnable
        property var subMenuModel: []
        property int subMenuIndex: 0

        required property var gamesListModel

        property bool filterOnlyFavorites: false
        property bool filterByDate: false

        property var currentCollection: {
//            return subMenuModel.get(collectionsMenuListView.currentIndex)
            return subMenuModel.get(collectionsMenuProxyModel.mapToSource(collectionsMenuListView.currentIndex))
        }

        property var currentGame: { 
            return gamesListModel.get(gamesListProxyModel.mapToSource(gamesListView.currentIndex))
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Left && subMenuEnable) {
                event.accepted = true;
                if (collectionsMenuListView.listView.currentIndex - 1 >= 0) {
                    collectionsMenuListView.listView.decrementCurrentIndex();
                    gamesListView.currentIndex = 0;
                    // Hacky force refresh of game media
                    gamesMediaLoader.active = false
                    gamesMediaLoader.active = true
                    Logger.debug("GamesListMenu:keys:left:currentSubMenu:" + currentCollection.name)
                }
                return;
            }
            
            if (event.key == Qt.Key_Right && subMenuEnable) {
                event.accepted = true;
                if (collectionsMenuListView.listView.currentIndex + 1 < collectionsMenuListView.listView.count) {
                    collectionsMenuListView.listView.incrementCurrentIndex();
                    gamesListView.currentIndex = 0;
                    // Hacky force refresh of game media
                    gamesMediaLoader.active = false
                    gamesMediaLoader.active = true
                    Logger.debug("GamesListMenu:keys:right:currentSubMenu:" + currentCollection.name)
                }
                return;
            }

            // TODO: Move to on release key event
            if (api.keys.isFilters(event)) {
                event.accepted = true;
                gamesListModel.get(gamesListProxyModel.mapToSource(gamesListView.currentIndex)).favorite =
                    !gamesListModel.get(gamesListProxyModel.mapToSource(gamesListView.currentIndex)).favorite   
                return;
            }

            if (api.keys.isAccept(event)) {
                event.accepted = true;
                Logger.info("GamesListMenu:keys:accept:launchingGame:" + currentGame.title);
                currentGame.launch();
                return;
            }

            if (api.keys.isPageUp(event)) {
                event.accepted = true;
                var count = gamesListView.model.count;
                var index = gamesListView.currentIndex - 10;
                if (index < 0) {index = 0;}
                gamesListView.currentIndex = index;
                return;
            }

            if (api.keys.isPageDown(event)) {
                event.accepted = true;
                var count = gamesListView.model.count;
                var index = gamesListView.currentIndex + 10;
                if (index >= count) {index = count - 1;}
                gamesListView.currentIndex = index;
                return;
            }
        }

        SortFilterProxyModel {
            id: collectionsMenuProxyModel

            sourceModel: themeData.collectionsListModel
            delayed: true
            sorters: [
                RoleSorter {
                    roleName: "sortBy"
                }
            ]

            Component.onCompleted: Logger.info("collections proxy model: " + sourceModel.count)
        }

        // TODO Only load or save when subMenuEnable is active
        SubMenu {
            id: collectionsMenuListView

            focus: false
            visible: subMenuEnable ? true : false
            enabled: subMenuEnable ? true : false

            width: parent.width * (themeSettings.subMenuWidth / 100)
            height: parent.height * (themeSettings.subMenuHeight / 100)

            columns: themeSettings.subMenuColumns

            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.06

            model: collectionsMenuProxyModel

            textName: {
                if (themeSettings.collectionShortNames) { return "shortName"};
                return "name";
            }

            currentIndex: {
                Logger.info("GamesListMenu:collectionsMenuListView:onCompleted")
                Logger.info("GamesListMenu:collectionsMenuListView:onCompleted:typeof:" + (typeof subMenuModel))
                Logger.info("GamesListMenu:collectionsMenuListView:onCompleted:count:" + (subMenuModel.length))
                for(var i=0; i < subMenuModel.count; ++i) {
                    Logger.info("DEBUG:" + subMenuModel.get(i).name)
                    if (subMenuModel.get(i).name === themeSettings["menuIndex_subMenu_name"]) {
                        return i;
                    }
                }
                return 0;
            }

            Component.onDestruction: {
                themeSettings["menuIndex_subMenu_name"] = collectionsMenuRoot.currentCollection.name; 
                themeSettings["menuIndex_subMenu"] = collectionsMenuListView.currentIndex; 
            }
            
        }

        SortFilterProxyModel {
            id: gamesListProxyModel
            sourceModel: collectionsMenuRoot.gamesListModel
            delayed: true
            filters: [
                ValueFilter {
                    enabled: collectionsMenuRoot.filterOnlyFavorites
                    roleName: "favorite"
                    value: true
                },
                RangeFilter {
                    enabled: collectionsMenuRoot.filterByDate
                    roleName: "playCount"
                    minimumValue: 1
                },
                ExpressionFilter {
                    enabled: collectionsMenuRoot.filterByDate 
                    expression: {
                        var dateOffset = (24 * 60 * 60 * 1000) * themeSettings.lastPlayedDays;
                        var myDate = new Date();
                        myDate.setTime(myDate.getTime() - dateOffset);
                        return (modelData.lastPlayed > myDate ? true : false);
                    }
                }
            ]
            proxyRoles: [
                ExpressionRole {
                    name: "lastPlayedEpoch"
                    expression: model.lastPlayed.getTime()
                }
            ]
            sorters: [
                RoleSorter {
                    enabled: !collectionsMenuRoot.filterByDate
                    roleName: "sortBy"
                },
                FilterSorter {
                    enabled: themeSettings.gamesFavoritesOnTop
                    priority: 1000
                    filters: [
                        ValueFilter {
                            roleName: "favorite"
                            value: true
                        }
                    ]
                },
                RoleSorter {
                    enabled: collectionsMenuRoot.filterByDate
                    roleName: "lastPlayedEpoch"
                    sortOrder: Qt.DescendingOrder
                }
            ]

            onModelReset: Logger.info("GamesListMenu:gamesListProxyModel:modelReset")

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

            model: gamesListProxyModel
            delegate: gamesListDelegate.delegate

            Component.onCompleted: {
                //const isGame = (element) => element.title === themeSettings["menuIndex_gamesList_name"]
                //let index = utils.findModelIndex(gamesListView.model, isGame); 
                let index = 0;
                Logger.info("GamesListMenu:gamesListView:onCompleted:modelAtIndex:" + gamesListView.model.get(themeSettings["menuIndex_gamesList"]).title)
                if (gamesListView.model.get(themeSettings["menuIndex_gamesList"]).title === themeSettings["menuIndex_gamesList_name"]) {
                    index = themeSettings["menuIndex_gamesList"]
                }
                Logger.info("GameListMenu:gameListView:onCompleted:savedIndex:" + index);
                gamesListView.moveIndex(index);
            }

            onCurrentIndexChanged: Logger.info("gamesListView:modelEpoch:" + model.get(currentIndex).lastPlayedEpoch)
            Component.onDestruction: { 
                Logger.debug("GamesListMenu:gamesListView:currentGame:" + collectionsMenuRoot.currentGame.title) 
                themeSettings["menuIndex_gamesList_name"] = collectionsMenuRoot.currentGame.title
                themeSettings["menuIndex_gamesList"] = gamesListView.currentIndex
            }

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

            footerLeftText: (gamesListView.currentIndex + 1) + "/" + gamesListProxyModel.count 

        }

        Loader {
            id: gamesMediaLoader
            sourceComponent: gamesMedia
            asynchronous: true
            visible: gamesListView.model.count > 0
            
            anchors.top: collectionsMenuListView.bottom
            anchors.topMargin: parent.height * 0.02
            anchors.right: parent.right
            anchors.left: gamesListView.right
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: parent.bottom
        }

        Component {
            id: gamesMedia
            GamesMedia01 {

                currentGame: gamesListView.model.get(gamesListView.currentIndex)
            }
        }

    }
}
