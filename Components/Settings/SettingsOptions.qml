import QtQuick 2.15

import "../Generic"
import "../Delegates"
import "../../Logger.js" as Logger

FocusScope {

    // property alias model: settingsListView.model
    property alias model: optionsRoot.settingModel

    Item {
        id: optionsRoot

        width: parent.width
        height: parent.height

        property var settingModel: []
        // property string settingType: ""

        Keys.onPressed: {
            if (api.keys.isAccept(event)) {
                //event.accepted = true
                themeSettings.saveSetting(optionsRoot.settingModel.id, settingsListView.model[settingsListView.currentIndex], optionsRoot.settingModel.type);
            }
        }

        // Component.onCompleted: {
        //     state = settingModel.type;
        // }

        onSettingModelChanged: {
            // settingsListView.model = settingModel.options;
            // settingType = settingModel.type;
            if (settingModel !== undefined) { 
                state = settingModel.type
                Logger.debug("SettingsOptions:onSettingModelChanged:state:" + state)
            };
            
            // Logger.info("Setting type: " + settingModel.type);
        }

        ItemList {
            id: settingsListView
            focus: true

            width: parent.width
            height: parent.height
            anchors.fill: parent
            rows: 4
            model: []
            delegate: settingsOptionsDelegate.delegate

            property string settingId: ""

            function setIndex() {
                Logger.debug("SettingsOptions:setIndex:model:" + model);
                if (model === undefined || model == [] || optionsRoot.settingModel == []) { return }
                var value = themeSettings[optionsRoot.settingModel.id];
                if (optionsRoot.settingModel.type == "bool") {
                    value = (value) ? "Enable" : "Disable"
                }
                Logger.debug("SettingsOptions:setIndex:value:"+ value);
                var index = utils.findIndexByValue(model, value);
                //if (index >= 0 || index !== undefined) { currentIndex = index };
                settingsListView.currentIndex = index;
            }

            // Component.onCompleted: setIndex()
            //onModelChanged: {
            onSettingIdChanged: {
                Logger.debug("SettingsOptions:onModelChanged:initiated");
                Logger.debug("SettingsOptions:onModelChanged:id:" + optionsRoot.settingModel.id);
                setIndex();
            }

            onModelChanged: {
                Logger.info("SettingsOptions:onModelChanged:model:" + model.count);
            }
        }

        SettingsOptionsDelegate {
            id: settingsOptionsDelegate
            rows: settingsListView.rows
            textName: ""
        }


        states: [
            State {
                name: "list"
                // when: settingType == "list"
                PropertyChanges {
                    target: settingsListView
                    model: {
                        const list = []
                        for(var i=0; i < optionsRoot.settingModel.options.count; ++i) {
                            list.push(optionsRoot.settingModel.options.get(i).value)
                        }
                        return list
                    }
                }
                PropertyChanges {
                    target: settingsListView
                    settingId: optionsRoot.settingModel.id
                }
            },
            State {
                name: "range"
                // when: settingType == "range"
                PropertyChanges {
                    target: settingsListView
                    model: utils.generateRangeModel(optionsRoot.settingModel.min, optionsRoot.settingModel.max, optionsRoot.settingModel.step)
                }
                PropertyChanges {
                    target: settingsListView
                    settingId: optionsRoot.settingModel.id
                }
            },
            State {
                name: "bool"
                // when: settingType == "bool"
                PropertyChanges {
                    target: settingsListView
                    model: ["Enable", "Disable"]
                }
                PropertyChanges {
                    target: settingsListView
                    settingId: optionsRoot.settingModel.id
                }
            },
            State {
                name: ""
            }
        ]

        onStateChanged: Logger.info("settingOptions:state:" + state)

    }


}
