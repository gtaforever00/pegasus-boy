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

    property string theme: {
        return "Default"
    }

    property var menuOptions: [
        { name: "collections", title: "Games"},
        { name: "favorites", title: "Favorite"},
        { name: "lastplayed", title: "Recent"},
        { name: "settings", title: "Settings"}
    ]


    ThemeSettings {
        id: themeSettings
    }

    ThemeData {
        id: themeData
    }

    Utils {
        id: utils
    }

    Loader {
        id: shaderLoader
        width: parent.width
        height: parent.height
        focus: true

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
