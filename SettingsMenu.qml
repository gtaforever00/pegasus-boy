import QtQuick 2.15
import QtGraphicalEffects 1.12

import "Logger.js" as Logger
import "Components/Generic"
import "Components/Delegates"
import "Components/SubMenu"
import "Components/GamesMedia"
import "Components/Settings"

FocusScope {

    SettingsOptionsModel {
        id: settingsData
    }

    Item {
        id: settingsMenuRoot
        width: parent.width
        height: parent.height

        focus: true

        property alias collectionsMenuListView: collectionsMenuListView

        property bool settingsOptionsActive: false

        Keys.onPressed: {
            if (event.key == Qt.Key_Left) {
                event.accepted = true;
                collectionsMenuListView.listView.decrementCurrentIndex();
                return;
            }
            
            if (event.key == Qt.Key_Right) {
                event.accepted = true;
                collectionsMenuListView.listView.incrementCurrentIndex();
                return;
            }

            if (api.keys.isAccept(event)) {
                event.accepted = true;
                if (settingsOptionsActive == false) {
                    settingsOptionsActive = true;
                    settingsOptions.forceActiveFocus();
                }
                else {
                    settingsOptionsActive = false;
                    settingsListView.forceActiveFocus();
                }
                return;
            }

            if (api.keys.isCancel(event)) {
                event.accepted = true;
                settingsListView.forceActiveFocus();
                return;
            }

        }

        SubMenu {
            id: collectionsMenuListView

            focus: false

            width: parent.width * (themeSettings.subMenuWidth / 100)
            height: parent.height * (themeSettings.subMenuHeight / 100)
            columns: themeSettings.subMenuColumns


            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.06

            model: settingsData.settingsListModel

        }


        ItemList {
            id: settingsListView
            focus: settingsMenuRoot.focus
            rows: themeSettings.itemListRows

            anchors.top: collectionsMenuListView.bottom
            anchors.topMargin: parent.height * 0.02
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.02
            anchors.bottom: parent.bottom

            width: parent.width * (themeSettings.itemListWidth / 100)

            model: collectionsMenuListView.model.get(collectionsMenuListView.currentIndex).settings
            delegate: settingsListDelegate.delegate
        }

        GamesListDelegate {
            id: settingsListDelegate
            rows: settingsListView.rows
            textName: "name"
        }

        Item {
            id: settingsInfo

            property int rows: 4



            anchors {
                top: collectionsMenuListView.bottom
                topMargin: parent.height * 0.02
                left: settingsListView.right
                leftMargin: parent.width * 0.02
                bottom: settingsOptions.top
                bottomMargin: parent.height * 0.02
                right: parent.right
                rightMargin: parent.width * 0.02
            }

            Text {
                id: settingsInfoDescription

                anchors.fill: parent

                font.family: "HackRegular"
                font.pixelSize: (parent.height / settingsInfo.rows) * 0.4
                color: themeData.colorTheme[theme].primary

                wrapMode: Text.WordWrap

                text: {
                    return "Description: " +
                        settingsListView.model.get(settingsListView.currentIndex).description;
                }
            }

            Text {
                id: settingsInfoDefault

                anchors.bottom: parent.bottom

                font.family: "HackRegular"
                font.pixelSize: (parent.height / settingsInfo.rows) * 0.3
                color: themeData.colorTheme[theme].primary

                text: {
                    Logger.info("SettingsMenu:settingsInfoDefault:" + settingsListView.model.get(settingsListView.currentIndex).default)
                    return "Default: " +
                    settingsListView.model.get(settingsListView.currentIndex).default;
                }

                onTextChanged: Logger.info("SettingsMenu:settingsInfoDefault:" + settingsListView.model.get(settingsListView.currentIndex).default)

            }
        }

        SettingsOptions {
            id: settingsOptions

            focus: false

            height: parent.height * 0.4

            anchors {
                left: settingsListView.right
                leftMargin: parent.width * 0.05
                bottom: parent.bottom
                right: parent.right
                rightMargin: parent.width * 0.05
            }

            model: settingsListView.model.get(settingsListView.currentIndex)

        }

    }
}
