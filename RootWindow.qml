import QtQuick 2.15
import "Logger.js" as Logger

Item {
    id: rootWindow

    // anchors.fill: parent

    Keys.onPressed: {
        //console.log("Root element keys: " + event)
        if (api.keys.isNextPage(event)) {
            event.accepted = true
            // console.log(menuTop.listView.currentIndex)
            menuItem.menuListView.incrementCurrentIndex()
            Logger.info("Menu Index: " + menuLoader.item.currentIndex)
            return
        }

        if (api.keys.isPrevPage(event)) {
            event.accepted = true
            menuItem.menuListView.decrementCurrentIndex()
            Logger.info("Menu Index: " + menuLoader.item.currentIndex)
            return
        }


    }

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: themeData.colorTheme[theme].background
    }

    property alias menuItem: menuLoader.item
    Loader {
        id: menuLoader
        focus: false
        width: parent.width
        height: parent.height * 0.14
        sourceComponent: menuComponent
        asynchronous: true
    }

    Component {
        id: menuComponent
        Menu {
            id: menu
            focus: menuLoader.focus
            currentIndex: themeSettings["menuIndex_main"]
        }
    }

    Loader {
        id: subHeaderLoader
        focus: false

    }

    property alias contentItem: contentLoader.item
    Loader {
        id: contentLoader
        focus: true
        sourceComponent: collectionsMenu
        asynchronous: true
        anchors {
            top: menuLoader.bottom
            //bottom: footerLoader.top
            bottomMargin: parent.height * 0.03
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    Component {
        id: collectionsMenu

        GamesListMenu {
            focus: contentLoader.focus
            subMenuEnable: true
            subMenuModel: themeData.collectionsModel
            gamesListModel: themeData.collectionsModel[collectionsMenuListView.currentIndex].games
            menuName: rootWindow.state

            Component.onCompleted: {
                Logger.info("RootWindow:collectionsMenu:onCompleted");
            }
        }
    }

    Component {
        id: favoritesMenu

        GamesListMenu {
            focus: contentLoader.focus
            subMenuEnable: false
            gamesListModel: api.allGames
            filterOnlyFavorites: true
            menuName: rootWindow.state
        }
    }

    Component {
        id: settingsMenu

        SettingsMenu {
            focus: contentLoader.focus
        }
    }

    Component {
        id: lastPlayedMenu

        GamesListMenu {
            focus: contentLoader.focus
            subMenuEnable: false
            gamesListModel: api.allGames
            filterByDate: true
            menuName: rootWindow.state
        }
    }

    // Loader {
    //     id: footerLoader
    //     height: parent.height * 0.08
    //     width: parent.width
    //     anchors.bottom: parent.bottom
    //     focus: false
    //     sourceComponent: footer
    //     asynchronous: true
    //     visible: status == Loader.Ready
    // }

    // Component {
    //     id: footer

    //     Footer {}
    // }

    states: [
        State {
            name: "games"
            when: menuItem.currentIndex == 0
            changes: [
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: collectionsMenu
                }
            ]
        },
        State {
            name: "favorites"
            when: menuItem.currentIndex == 1
            changes: [
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: favoritesMenu
                }
            ]
        },
        State {
            name: "lastplayed"
            when: menuItem.currentIndex == 2
            changes: [
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: lastPlayedMenu
                }
            ]
        },
        State {
            name: "settings"
            when: menuItem.currentIndex == 3
            PropertyChanges {
                target: contentLoader
                sourceComponent: settingsMenu
            }
        }
    ]

    onStateChanged: {
        Logger.info("rootWindow:stateChanged:state:" + state);
        if (menuItem !== null) {
            themeSettings["menuIndex_main"] = menuItem.currentIndex;
        }
    }

    Component.onCompleted: {
        Logger.info("rootWindow:onCompleted");
        if (menuItem !== null) {
            menuItem.currentIndex = themeSettings["menuIndex_main"];
        }
    }

}
