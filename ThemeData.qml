import QtQuick 2.15

import "Logger.js" as Logger

Item {

    // Add an All to the main collections model
    // Dynamically create a ListModel to keep compatability
    property alias collectionsListModel: collectionsListModel
    ListModel {
        id: collectionsListModel 

        Component.onCompleted: {
            const collections = api.collections
            const allCollection = {
                name: "All",
                shortName: "all",
                games: api.allGames
            }

            if (themeSettings.collectionAllGames) {
                collectionsListModel.append(allCollection)
            }

            for (var i=0; i < collections.count; ++i) {
                collectionsListModel.append(collections.get(i))
            }
        }
    }

    property var allGamesModel: {
        return api.allGames;
    }


    property var colorTheme: {
        "Default": {
            background: "#181810",
            primary: "#00ee00",
            secondary: "#005f00",
            light: "#008e00",
            dark: "#005200",
            dark2: "#002f00"
        },
        "Amber": {
            background: "#140d00",
            primary: "#ffa91f",
            secondary: "#f59700",
            light: "#e08a00",
            dark: "#7a4b00",
        },
        "Blue": {
            background: "#001014",
            primary: "#2ecfff",
            secondary: "#00bcf5",
            light: "#00ace0",
            dark: "#005e7a",
        },
        "Purple": {
            background: "#0b0410",
            primary: "#9d5ed4",
            secondary: "#7f33c1",
            light: "#6f2da8",
            dark: "#401a61",
        },
    }

    property var languageNames: {
        "en": "English"
    }

    // Language shortcodes https://www.science.co.il/language/Codes.php
    property var text: {
        "en": {
            "menu_collections": "Games",
            "menu_favorites": "Favorites",
            "menu_lastplayed": "Last Played",
            "menu_settings": "Settings"
        }
    }

    property var font: {
        "HackRegular": ""
    }

}
