import QtQuick 2.15

import "Logger.js" as Logger

// All settings defined here
// Defaults are listed above
Item {
    id: themeSettings

    // property var settingsEnum: {
    //     "theme": theme,
    //     "menuItemCount": menuItemCount,
    //     "collectionItemCount": collectionItemCount
    // }

    // Add settings here to auto load from Pegasus
    property var settingsList: [
        "theme",
        "lastPlayedDays",
        "itemListRows",
        "itemListWidth",
        "subMenuColumns",
        "subMenuWidth",
        "subMenuHeight",
        "language",
        "collectionAllGames",
        "collectionShortNames",
        "shaderEnable",
        "shaderCurvatureEnable",
        "shaderScanlinesEnable",
        "shaderScanlinesImageSize",
        "menuIndex_main",
        "menuIndex_subMenu",
        "menuIndex_subMenu_name",
        "menuIndex_gamesList",
        "menuIndex_gamesList_name",
        "gamesFavoritesOnTop",
        "gamesListCounter",
    ]


    property string theme: "Default"

    property int settingsVersion: 1

    // Application state

    property int menuIndex_main: 0
    property int menuIndex_subMenu: 0
    property int menuIndex_gamesList: 0
    
    property string menuIndex_subMenu_name: ""
    property string menuIndex_gamesList_name: ""

    // User configurable settings
    property string lastPlayedDays: "30"

    property int itemListRows: 9
    property int itemListWidth: 40

    property int subMenuColumns: 4
    property int subMenuWidth: 55
    property int subMenuHeight: 6

    property bool collectionAllGames: true
    property bool collectionShortNames: false
    property bool gamesFavoritesOnTop: false

    property bool gamesListCounter: true

    property string language: "en"

    property bool shaderEnable: true
    property bool shaderCurvatureEnable: true
    property bool shaderScanlinesEnable: true
    property int shaderScanlinesImageSize: 180


    // Try to load the setting if not use default
    function loadSetting(name) {
        var value = api.memory.get(name);
        if (value === undefined) {
            Logger.warn("themeSettings:loadSetting:" + name + ":undefined");
            value = themeSettings[name];
        }
        Logger.info("themeSettings:loadSetting:" + name + ":value:" + value);
        return value;
    }

    function saveSetting(name, value, type="value") {
        let v = value;
        if (type == "bool") {
            v = (value.toLowerCase() === "enable");
        }
        themeSettings[name] = v;
        api.memory.set(name, v);
        Logger.info("themeSettings:saveSetting:" + name + ":value:" + v);
        api.memory.set("settingsVersion", settingsVersion);
    }

    function loadAllSettings() {
        for(let i=0; i < settingsList.length; i++) {
            themeSettings[settingsList[i]] = loadSetting(settingsList[i]);
        };
    }

    function saveAllSettings() {
        for(let i=0; i < settingsList.length; i++) {
            saveSetting(settingsList[i], themeSettings[settingsList[i]]);
        }
    }

    // Load settings
    Component.onCompleted: {
        loadAllSettings();
    }

    // Save settings
    Component.onDestruction: {
        saveAllSettings();
    }

}
