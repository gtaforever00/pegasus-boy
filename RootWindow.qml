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
            menuLoader.item.menuIndex.incrementCurrentIndex()
            Logger.info("Menu Index: " + menuLoader.item.menuIndex.currentIndex)
            return
        }

        if (api.keys.isPrevPage(event)) {
            event.accepted = true
            menuLoader.item.menuIndex.decrementCurrentIndex()
            Logger.info("Menu Index: " + menuLoader.item.menuIndex.currentIndex)
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
        }
    }

    Loader {
        id: subHeaderLoader
        focus: false

    }

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

        CollectionsMenu {
            focus: contentLoader.focus
        }
    }

    Component {
        id: favoritesMenu

        FavoritesMenu {
            focus: contentLoader.focus
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

        LastPlayedMenu {
            focus: contentLoader.focus
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
            when: menuItem.menuIndex.currentIndex == 0
            PropertyChanges {
                target: contentLoader
                sourceComponent: collectionsMenu
            }
        },
        State {
            name: "favorites"
            when: menuItem.menuIndex.currentIndex == 1
            PropertyChanges {
                target: contentLoader
                sourceComponent: favoritesMenu
            }
        },
        State {
            name: "lastplayed"
            when: menuItem.menuIndex.currentIndex == 2
            PropertyChanges {
                target: contentLoader
                sourceComponent: lastPlayedMenu
            }
        },
        State {
            name: "settings"
            when: menuItem.menuIndex.currentIndex == 3
            PropertyChanges {
                target: contentLoader
                sourceComponent: settingsMenu
            }
        }
    ]

    onStateChanged: Logger.info("rootWindow state is: " + state )

}