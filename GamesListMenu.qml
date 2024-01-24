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

        property alias collectionsMenuListView: collectionsMenuLoader.item
        property alias gamesListView: gamesListLoader.item
        
        required property string menuName

        required property bool subMenuEnable
        property var subMenuModel: []
        property int subMenuIndex: 0

        required property var gamesListModel

        property bool filterOnlyFavorites: false
        property bool filterByDate: false

        property var currentCollection: {
            return subMenuModel.get(collectionsMenuLoader.item.currentIndex)
//            return subMenuModel.get(subMenuModel.mapToSource(collectionsMenuLoader.item.currentIndex))
        }

        property var currentGame: { 
            return gamesListModel.get(gamesListModelLoader.item.mapToSource(gamesListLoader.item.currentIndex))
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Left && subMenuEnable) {
                event.accepted = true;
                if (collectionsMenuLoader.item.listView.currentIndex - 1 >= 0) {
                    collectionsMenuLoader.item.listView.decrementCurrentIndex();
                    gamesListLoader.item.currentIndex = 0;
                    // Hacky force refresh of game media
                    gamesMediaLoader.active = false
                    gamesMediaLoader.active = true
                    gamesListLoader.active = false
                    gamesListLoader.active = true
                    Logger.debug("GamesListMenu:keys:left:currentSubMenu:" + currentCollection.name)
                }
                return;
            }
            
            if (event.key == Qt.Key_Right && subMenuEnable) {
                event.accepted = true;
                if (collectionsMenuLoader.item.listView.currentIndex + 1 < collectionsMenuLoader.item.listView.count) {
                    collectionsMenuLoader.item.listView.incrementCurrentIndex();
                    gamesListLoader.item.currentIndex = 0;
                    // Hacky force refresh of game media
                    gamesMediaLoader.active = false
                    gamesMediaLoader.active = true
                    gamesListLoader.active = false
                    gamesListLoader.active = true
                    Logger.debug("GamesListMenu:keys:right:currentSubMenu:" + currentCollection.name)
                }
                return;
            }

            // TODO: Move to on release key event
            if (api.keys.isFilters(event)) {
                event.accepted = true;
                gamesListModel.get(gamesListModelLoader.item.mapToSource(gamesListLoader.item.currentIndex)).favorite =
                    !gamesListModel.get(gamesListModelLoader.item.mapToSource(gamesListLoader.item.currentIndex)).favorite   
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
                var count = gamesListLoader.item.model.count;
                var index = gamesListLoader.item.currentIndex - 10;
                if (index < 0) {index = 0;}
                gamesListLoader.item.currentIndex = index;
                return;
            }

            if (api.keys.isPageDown(event)) {
                event.accepted = true;
                var count = gamesListLoader.item.model.count;
                var index = gamesListLoader.item.currentIndex + 10;
                if (index >= count) {index = count - 1;}
                gamesListLoader.item.currentIndex = index;
                return;
            }
        }

        // SortFilterProxyModel {
        //     id: collectionsMenuProxyModel

        //     sourceModel: themeData.collectionsListModel
        //     delayed: true
        //     sorters: [
        //         RoleSorter {
        //             roleName: "sortBy"
        //         }
        //     ]

        //     Component.onCompleted: Logger.info("collections proxy model: " + sourceModel.count)
        // }

        Loader {
            id: collectionsMenuLoader
            sourceComponent: collectionsMenuListView
            active: subMenuEnable

            width: parent.width * (themeSettings.subMenuWidth / 100)
            height: parent.height * (themeSettings.subMenuHeight / 100)
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.06

            onStatusChanged: {
                if (collectionsMenuLoader.status == Loader.Ready) {
                    Logger.info("GamesListMenu:collectionsMenuLoader:LoaderReady")

                    Logger.info("GamesListMenu:collectionsMenuListView:onCompleted:index:" + item.model.get(themeSettings["menuIndex_subMenu"]).name)

                    let index = 0
                    if (item.model.get(themeSettings["menuIndex_subMenu"]).name === themeSettings["menuIndex_subMenu_name"]) {
                        index = themeSettings["menuIndex_subMenu"]
                    }
                    item.moveIndex(index)

                    
                    gamesListModelLoader.active = true
                }
            }
        }

        Component {
            id: collectionsMenuListView

            SubMenu {
                focus: false

                model: subMenuModel

                textName: {
                    if (themeSettings.collectionShortNames) { return "shortName"};
                    return "name";
                }

                Component.onDestruction: {
                    themeSettings["menuIndex_subMenu_name"] = collectionsMenuRoot.currentCollection.name; 
                    themeSettings["menuIndex_subMenu"] = currentIndex; 
                }

                Component.onCompleted: {
                    Logger.info("GamesListMenu:collectionsMenuListView:onCompleted")
                }
                
            }
        }

        Loader {
            id: gamesListModelLoader
            sourceComponent: gamesListProxyModel
            active: subMenuEnable ? false : true

            onStatusChanged: {
                if (gamesListModelLoader.status == Loader.Ready) {
                    Logger.info("GamesListMenu:gamesListModelLoader:LoaderReady")
                    gamesListLoader.active = true
                }
            }
        }

        Component {
            id: gamesListProxyModel
            SortFilterProxyModel {
                sourceModel: gamesListModel

                delayed: false
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

                onModelReset: {
                    Logger.info("GamesListMenu:gamesListProxyModel:modelReset")
                }

                onLayoutChanged: {
                    Logger.info("GamesListMenu:gamesListProxyModel:layoutChanged")
                }

                Component.onCompleted: {
                    Logger.info("GamesListMenu:gamesListProxyModel:onComplete")
                }

            }
        }

        Loader {
            id: gamesListLoader

            focus: true
            sourceComponent: gamesListView
            active: false
           
            anchors.top: collectionsMenuLoader.bottom
            anchors.topMargin: parent.height * 0.02
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: footer.top

            width: parent.width * (themeSettings.itemListWidth / 100)

        }

        Component {
            id: gamesListView
            ItemList {
                focus: true

                rows: themeSettings.itemListRows

                model: gamesListModelLoader.item
                delegate: gamesListDelegate.delegate

                Component.onCompleted: {
                    //const isGame = (element) => element.title === themeSettings["menuIndex_gamesList_name"]
                    //let index = utils.findModelIndex(gamesListView.model, isGame); 
                    let index = 0;
                    Logger.info("GamesListMenu:gamesListView:onCompleted:modelAtIndex:" + model.get(themeSettings["menuIndex_gamesList"]).title)
                    if (model.get(themeSettings["menuIndex_gamesList"]).title === themeSettings["menuIndex_gamesList_name"]) {
                        index = themeSettings["menuIndex_gamesList"]
                    }
                    Logger.info("GameListMenu:gameListView:onCompleted:savedIndex:" + index);
                    moveIndex(index);
                }

                onCurrentIndexChanged: Logger.info("gamesListView:modelEpoch:" + model.get(currentIndex).lastPlayedEpoch)
                Component.onDestruction: { 
                    Logger.debug("GamesListMenu:gamesListView:currentGame:" + collectionsMenuRoot.currentGame.title) 
                    themeSettings["menuIndex_gamesList_name"] = collectionsMenuRoot.currentGame.title
                    themeSettings["menuIndex_gamesList"] = currentIndex
                }

            }
        }

        GamesListDelegate {
            id: gamesListDelegate
            rows: gamesListLoader.item.rows
        }

        Footer {
            id: footer

            height: parent.height * 0.1
            width: parent.width
            anchors.bottom: parent.bottom
            focus: false

            footerLeftText: (gamesListLoader.item.currentIndex + 1) + "/" + gamesListModelLoader.item.count 

        }

        Loader {
            id: gamesMediaLoader
            sourceComponent: gamesMedia
            asynchronous: true
            visible: gamesListLoader.item.model.count > 0
            active: gamesListLoader.status == Loader.Ready
            
            anchors.top: collectionsMenuLoader.bottom
            anchors.topMargin: parent.height * 0.02
            anchors.right: parent.right
            anchors.left: gamesListLoader.right
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: parent.bottom
        }

        Component {
            id: gamesMedia
            GamesMedia01 {

                currentGame: gamesListLoader.item.model.get(gamesListLoader.item.currentIndex)
            }
        }


        Component.onCompleted: {
            Logger.info("GamesListMenu:collectionsMenuRoot:onComplete")
        }

    }
}
