import QtQuick 2.15

import "Logger.js" as Logger

FocusScope {
    id: root

    focus: true

    FontLoader {
        id: hackRegularFont
        name: "HackRegular"
        source: "./assets/fonts/Hack/Hack-Regular.ttf"
    }

    property var menuOptions: [
        { name: "collections", title: "Games"},
        { name: "favorites", title: "Favorite"},
        { name: "lastplayed", title: "Recent"},
        { name: "settings", title: "Settings"}
    ]

    Loader {
        id: themeSettingsLoader
        sourceComponent: themeSettingsComponent

        onStatusChanged: {
            if (status == Loader.Ready) {
                //root.theme = item.theme
                themeDataLoader.active = true
            }
        }

    }

    Component {
        id: themeSettingsComponent
        ThemeSettings {
        }
    }
    property alias themeSettings: themeSettingsLoader.item

    // TODO: Fix all of the instances of this to use themeSettings
    property string theme: themeSettingsLoader.item.theme

    // Binding {
    //     target: theme
    //     when: themeSettingsLoader.status == Loader.Ready
    //     value: themeSettingsLoader.item.theme
    // }

    Loader {
        id: themeDataLoader
        sourceComponent: themeDataComponent
        active: false

        onStatusChanged: {

            if (status == Loader.Ready) {
                shaderLoader.active = true
            }
        }
    }

    Component {
        id: themeDataComponent
        ThemeData {
        }
    }
    property alias themeData: themeDataLoader.item

    Utils {
        id: utils
    }

    Loader {
        id: shaderLoader
        width: parent.width
        height: parent.height
        focus: true
        active: false

        sourceComponent: shaderComponent
        visible: status == Loader.Ready
    }

    Component {
        id: shaderComponent

        Shaders {
            id: shaderEffects
            width: parent.width
            height: parent.height

        }
    }

}
