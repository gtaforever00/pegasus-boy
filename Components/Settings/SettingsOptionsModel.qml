import QtQuick 2.15

import "../../Logger.js" as Logger

Item {

    // Each settings needs a type and value
    // The rendering and options available depend on
    // the type of setting
    // id: Matches to the relevant themeSettings value
    // types:
    //   - list
    //   - bool
    //   - range (min, max, step)
    // TODO Change this to a list model
    property var settingsModel: [
        {
            "name": "General",
            "settings": [
                // {
                //     "name": "Language",
                //     "id": "language",
                //     "description": "Change the theme's language",
                //     "type": "list",
                //     "default": "en",
                //     "options": ["en"],
                // },
                {
                    "name": "Theme",
                    "id": "theme",
                    "description": "Color theme",
                    "type": "list",
                    "default": "Default",
                    "options": [
                        { "value": "Default" },
                        { "value": "Amber" },
                        { "value": "Blue" },
                        { "value": "Purple" },
                    ]
                },
                {
                    "name": "Last Played Day Range",
                    "id": "lastPlayedDays",
                    "description": "The max number of days to show games on the last played menu",
                    "type": "list",
                    "default": "30",
                    "options": [
                        { "value": "7" },
                        { "value": "14" },
                        { "value": "30" },
                        { "value": "60" },
                        { "value": "90" },
                        { "value": "180" },
                        { "value": "365" },
                    ]
                },
                {
                    "name": "Show All Games",
                    "id": "collectionAllGames",
                    "description": "Show All games in the games list",
                    "type": "bool",
                    "default": "Enable",
                },
                {
                    "name": "Collection Short Names",
                    "id": "collectionShortNames",
                    "description": "Use collection short names",
                    "type": "bool",
                    "default": "Disable",
                },
                {
                    "name": "Show favorites on top",
                    "id": "gamesFavoritesOnTop",
                    "description": "Show favorites on top of the games list",
                    "type": "bool",
                    "default": "Disable",
                },
                {
                    "name": "Show counter in footer",
                    "id": "gamesListCounter",
                    "description": "Display a counter for the game index in the footer of the games list",
                    "type": "bool",
                    "default": "Enable",
                },
            ]
        },
        {
            "name": "Layout",
            "settings": [
                {
                    "name": "Main List - Rows",
                    "id": "itemListRows",
                    "description": "The number of rows to show on the game/settings lists",
                    "type": "range",
                    "default": "9",
                    "min": 4,
                    "max": 12,
                    "step": 1,
                },
                {
                    "name": "Main List - Width",
                    "id": "itemListWidth",
                    "description": "The percentage of width of the game/settings lists.",
                    "type": "range",
                    "default": "40",
                    "min": 35,
                    "max": 65,
                    "step": 5,
                },
                {
                    "name": "Sub-Menu - Columns",
                    "id": "subMenuColumns",
                    "description": "The number of sub menu items to show on the screen.",
                    "type": "range",
                    "default": "4",
                    "min": 3,
                    "max": 8,
                    "step": 1,
                },
                {
                    "name": "Sub-Menu - Width",
                    "id": "subMenuWidth",
                    "description": "The percentage of width of the screen to define the width of the Sub-Menu",
                    "type": "range",
                    "default": "55",
                    "min": 40,
                    "max": 90,
                    "step": 5,
                },
                {
                    "name": "Sub-Menu - Height",
                    "id": "subMenuHeight",
                    "description": "The percentage of height of the screen to define the height of the Sub-Menu",
                    "type": "range",
                    "default": "6",
                    "min": 4,
                    "max": 12,
                    "step": 1,
                },
            ]
        },
        {
            "name": "Shaders",
            "visible": false,
            "settings": [
                {
                    "name": "Shaders - Global",
                    "id": "shaderEnable",
                    "description": "Enable the global shader support",
                    "type": "bool",
                    "default": "Enable",
                },
                {
                    "name": "Curvature - Enable",
                    "id": "shaderCurvatureEnable",
                    "description": "Enable the screen curvature",
                    "type": "bool",
                    "default": "Enable",
                },
                {
                    "name": "Scanlines - Enable",
                    "id": "shaderScanlinesEnable",
                    "description": "Enable scanline shader",
                    "type": "bool",
                    "default": "Enable",
                },
                {
                    "name": "Scanline Distance",
                    "id": "shaderScanlinesImageSize",
                    "description": "Sets the scanline virtual image size.  Can help even out or fix scanlines on different resolutions.",
                    "type": "range",
                    "default": "180",
                    "min": 144,
                    "max": 288,
                    "step": 1,

                }
            ]
        }
    ]

    property alias settingsListModel: settingsListModel
    ListModel {
        id: settingsListModel

        Component.onCompleted: {
            settingsModel.forEach((x) => {
                settingsListModel.append(x);
            })
            
            Logger.info("SettingsOptionsModel:settingsListModel:count:" + settingsListModel.count)
            Logger.info("SettingsOptionsModel:settingsListModel:element:" + settingsListModel.get(0).name)
        }
    }

}
