import QtQuick 2.15

Item {

    // Add an All to the main collections model
    property var collectionsModel: {
        var collections = api.collections.toVarArray();
        if (themeSettings.collectionAllGames) {
            collections.unshift(
                {
                    "name": "All",
                    "shortName": "all",
                    "games": api.allGames
                }
            );
        }
        return collections;
    }


    property var colorTheme: {
        "Default": {
            background: "#181810",
            primary: "#00ee00",
            secondary: "#005f00",
            light: "#008e00",
            dark: "#002f00"
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