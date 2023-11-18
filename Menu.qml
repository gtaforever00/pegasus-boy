import QtQuick 2.15

FocusScope {

    // focus: menu.focus
    //property alias testString: menuRoot.testString
    //property alias currentIndex: menuRoot
    property alias currentIndex: menuRoot.currentIndex
    property alias menuListView: menuRoot.listView


    Item {
        id: menuRoot
        property alias currentIndex: menuListView.currentIndex
        property alias listView: menuListView
        // width: parent.width * 0.7
        // height: parent.height * 0.7
        width: parent.width * 0.95
        height: parent.height * 0.95

        property string testString: "You got it!!"

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            //topMargin: parent.height * 0.3
        }

        ListView {
            id: menuListView

            property int fontSize: 12
            property int columns: {
                if (menuListView.count <= 5) {
                    return menuListView.count;
                }
                else {
                    // Keep max columns to 5 for top menu
                    return 5;
                }
            }

            focus: menuRoot.focus

            height: parent.height
            width: parent.width

            // https://stackoverflow.com/questions/47062880/qml-text-size-based-on-container
            // https://stackoverflow.com/questions/51162423/qml-binding-loop-detected-when-trying-to-calculate-font-size-automatically
            TextMetrics {
                id: menuListFont
                font.family: "HackRegular"
                font.bold: true
                font.capitalization: Font.AllUppercase
            }

            function calculateFontSize(minSize = 8, maxSize = 72) {
                //property int fontSize = menuListFont.font.pixelSize;
                // Minimum size
                var size = maxSize;
                var eWidth = (menuListView.width / menuListView.columns) * 0.8;
                var eHeight = menuListView.height;
                console.log("The width of e:" + eWidth);
                console.log("The height of e: " + eHeight)
                model.forEach((item) => {
                    var fSize;
                    //menuListFont.text = item.title;
                    menuListFont.font.pixelSize = eHeight;
                    menuListFont.text = item.title;
                    var brect = menuListFont.boundingRect;
                    console.log("brect width: " + brect.width);
                    console.log("brect height: " + brect.height);
                    if (brect.width > eWidth) {
                        var k = eWidth / brect.width;
                        fSize = Math.floor(menuListFont.font.pixelSize * k);
                    }
                    else {
                        fSize = menuListFont.font.pixelSize;
                    }

                    if (fSize < size) {
                        size = fSize;
                    }
                });
                
                return size;
            }

            model: menuOptions
            delegate: menuListDelegate

            orientation: ListView.Horizontal
            //spacing: contentItem.childrenRect.width * 0.02

            interactive: false
            clip: true
            currentIndex: root.currentmenuIndex

            Keys.onPressed: {
                if (api.keys.isNextPage(event)) {
                    event.accepted = true;
                    menuListView.incrementCurrentIndex();
                }
                else if (api.keys.isPrevPage(event)) {
                    event.accepted = true;
                    menuListView.decrementCurrentIndex();
                }
            }

            function resizeFont() {
                fontSize = utils.calculateFontSizeModel(menuListFont.font, 
                    (menuListView.width / menuListView.columns) * 0.8,
                    menuListView.height, 
                    model.map((x) => x.title)
                );

            }

            onHeightChanged: resizeFont()
            onWidthChanged: resizeFont()

            Component.onCompleted: {
                //fontSize = calculateFontSize()
                // fontSize = utils.calculateFontSizeModel(menuListFont.font, 
                //     (menuListView.width / menuListView.columns) * 0.8,
                //     menuListView.height, 
                //     model.map((x) => x.title)
                // )
                resizeFont()
                console.log("menu Listview loaded")
                console.log("Root Current Index: " + root.currentmenuIndex)

                //currentIndex = root.currentmenuIndex
            }

            onCurrentIndexChanged: {
                console.log("menu current index changed")
                positionViewAtIndex(currentIndex, ListView.View)
            }

        }


        Component {
            id: menuListDelegate

            Rectangle {
                id: menuTextRect

                property alias menuText: menuText

                width: ListView.view.width / ListView.view.columns
                height: ListView.view.height

                color: ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].background
                //color: ListView.isCurrentItem ? themeData.colorTheme[theme].primary : themeData.colorTheme[theme].background

                Text {
                    id: menuText
                    text: modelData.title

                    font.family: "HackRegular"
                    font.pixelSize: menuListView.fontSize
                    font.bold: true
                    //color: menuTextRect.ListView.isCurrentItem ? themeData.colorTheme[theme].background : themeData.colorTheme[theme].primary
                    color: themeData.colorTheme[theme].primary
                    font.capitalization: Font.AllUppercase

                    //anchors.centerIn: parent
                    anchors {
                        //centerIn: parent
                        bottom: parent.bottom
                        bottomMargin: parent.height * 0.02
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.03
                    color: themeData.colorTheme[theme].primary

                    visible: menuTextRect.ListView.isCurrentItem ? false : true

                    anchors.bottom: parent.bottom
                }

                Item {
                    id: menuTextActiveBorder
                    width: parent.width
                    height: parent.height

                    TextMetrics {
                        id: menuTextMetric

                        font: menuTextRect.menuText.font
                        text: menuTextRect.menuText.text
                    }

                    Rectangle {
                        id: menuTextActiveBorderBottomLeft
                        width: (parent.width - menuTextMetric.width) / 4
                        height: parent.height * 0.03
                        color: themeData.colorTheme[theme].primary

                        visible: menuTextRect.ListView.isCurrentItem ? true : false

                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                    }

                    Rectangle {
                        id: menuTextActiveBorderLeft
                        width: parent.height * 0.03
                        //height: parent.height / 2
                        height: menuTextMetric.height / 2
                        color: themeData.colorTheme[theme].primary

                        visible: menuTextRect.ListView.isCurrentItem ? true : false
                        anchors.left: menuTextActiveBorderBottomLeft.right
                        anchors.bottom: parent.bottom
                    }

                    Rectangle {
                        id: menuTextActiveBorderTopLeft

                        height: parent.height * 0.03
                        width: (parent.width - menuTextMetric.width) / 5

                        color: themeData.colorTheme[theme].primary
                        visible: menuTextRect.ListView.isCurrentItem ? true : false
                        anchors.left: menuTextActiveBorderLeft.right
                        anchors.top: menuTextActiveBorderLeft.top
                    }

                    Rectangle {
                        id: menuTextActiveBorderBottomRight
                        width: (parent.width - menuTextMetric.width) / 4
                        height: parent.height * 0.03
                        color: themeData.colorTheme[theme].primary

                        visible: menuTextRect.ListView.isCurrentItem ? true : false

                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }

                    Rectangle {
                        id: menuTextActiveBorderRight
                        width: parent.height * 0.03
                        //height: parent.height / 2
                        height: menuTextMetric.height / 2
                        color: themeData.colorTheme[theme].primary

                        visible: menuTextRect.ListView.isCurrentItem ? true : false
                        anchors.right: menuTextActiveBorderBottomRight.left
                        anchors.bottom: parent.bottom
                    }

                    Rectangle {
                        id: menuTextActiveBorderTopRight

                        height: parent.height * 0.03
                        width: (parent.width - menuTextMetric.width) / 5

                        color: themeData.colorTheme[theme].primary
                        visible: menuTextRect.ListView.isCurrentItem ? true : false
                        anchors.right: menuTextActiveBorderRight.left
                        anchors.top: menuTextActiveBorderRight.top
                    }



                }



            }
        }
    }

}
