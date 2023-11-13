import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {

    property alias footerLeftText: footerLeftText.text

    Item {
        id: footerRoot

        height: parent.height * 0.8
        width: parent.width * 0.95
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter


        Rectangle {
            id: footerLeft

            height: parent.height
            width: parent.width * 0.20


            color: themeData.colorTheme[themeSettings.theme].secondary

            Item {
                id: footerLeftImage
                height: parent.height
                width: height

                visible: footerLeftText != ""

                Rectangle {
                    id: footerLeftImageRect
                    height: parent.height
                    width: parent.width
                    color: themeData.colorTheme[theme].primary
                    visible: false
                }

                Image {
                    id: footerLeftImageMask
                    height: parent.height
                    width: height
                    fillMode: Image.PreserveAspectFit

                    source: "assets/retroarch-assets/file.png"
                    asynchronous: true

                    visible: false
                }

                OpacityMask {
                    id: footerLeftImageOpacityMask

                    anchors.fill: parent
                    source: footerLeftImageRect
                    maskSource: footerLeftImageMask
                }
            }

            Text {
                id: footerLeftText

                anchors.left: footerLeftImage.right
                //anchors.leftMargin: parent.width * 0.01
                anchors.verticalCenter: parent.verticalCenter


                font.family: "HackRegular"
                font.pixelSize: parent.height * 0.7
                color: themeData.colorTheme[theme].primary

                text: ""
            }
        }

        Rectangle {
            id: footerMiddle

            height: parent.height
            width: parent.width * 0.20
            anchors.left: footerLeft.right
            anchors.leftMargin: parent.width * 0.01

            color: themeData.colorTheme[themeSettings.theme].secondary

            Item {
                id: footerMiddleClock

                anchors.fill: parent
                anchors.leftMargin: parent.width * 0.03

                Timer {
                    interval: 1000
                    running: true
                    repeat: true

                    onTriggered: {
                        var date = new Date();
                        var options = {
                            hour: "numeric",
                            minute: "numeric",
                        }
                        footerMiddleTime.text = date.toLocaleTimeString('en-US');
                    }
                }

                Text {
                    id: footerMiddleTime
                    // anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "HackRegular"
                    font.pixelSize: parent.height * 0.7
                    color: themeData.colorTheme[theme].primary

                    text: { new Date().toLocaleTimeString('en-US') }
                }
            }
        }

        Rectangle {
            id: footerRight

            height: parent.height
            anchors.left: footerMiddle.right
            anchors.leftMargin: parent.width * 0.01
            anchors.right: parent.right

            color: themeData.colorTheme[themeSettings.theme].secondary

            Rectangle {
                id: footerRightAcceptCircle

                height: parent.height * 0.6
                width: height

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.03

                color: themeData.colorTheme[themeSettings.theme].primary
                radius: 180

                Text {
                    id: footerRightAcceptCircleLetter

                    //anchors.left: footerLeftImage.right
                    //anchors.leftMargin: parent.width * 0.01
                    //anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter


                    font.family: "HackRegular"
                    font.pixelSize: parent.height * 0.8
                    font.bold: true
                    color: themeData.colorTheme[theme].background

                    text: "A"
                }

            }

            Text {
                id: footerRightAcceptText

                anchors.left: footerRightAcceptCircle.right
                anchors.leftMargin: parent.width * 0.01
                anchors.verticalCenter: parent.verticalCenter

                font.family: "HackRegular"
                font.pixelSize: footerRightAcceptCircle.height * 0.8
                color: themeData.colorTheme[theme].primary

                text: "Accept"

            }

            Rectangle {
                id: footerRightFavoriteCircle

                height: parent.height * 0.6
                width: height

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: footerRightAcceptText.right
                anchors.leftMargin: parent.width * 0.03

                color: themeData.colorTheme[themeSettings.theme].primary
                radius: 180

                Text {
                    id: footerRightFavoriteCircleLetter

                    //anchors.left: footerLeftImage.right
                    //anchors.leftMargin: parent.width * 0.01
                    //anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter


                    font.family: "HackRegular"
                    font.pixelSize: parent.height * 0.8
                    font.bold: true
                    color: themeData.colorTheme[theme].background

                    text: "Y"
                }

            }

            Text {
                id: footerRightFavoriteText

                anchors.left: footerRightFavoriteCircle.right
                anchors.leftMargin: parent.width * 0.01
                anchors.verticalCenter: parent.verticalCenter

                font.family: "HackRegular"
                font.pixelSize: footerRightFavoriteCircle.height * 0.8
                color: themeData.colorTheme[theme].primary

                text: "Favorite"

            }


            Rectangle {
                id: footerRightPrevPageRect

                height: parent.height * 0.6
                width: height * 1.5
                anchors.left: footerRightFavoriteText.right
                anchors.leftMargin: parent.width * 0.02
                anchors.verticalCenter: parent.verticalCenter

                radius: 3

                color: themeData.colorTheme[themeSettings.theme].primary

                Text {
                    id: footerRightPrevPageRectLetter

                    //anchors.left: footerLeftImage.right
                    //anchors.leftMargin: parent.width * 0.01
                    //anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter


                    font.family: "HackRegular"
                    font.pixelSize: parent.height * 0.8
                    font.bold: true
                    color: themeData.colorTheme[theme].background

                    text: "L1"
                }
            }

            Text {
                id: footerRightPrevPageText

                anchors.left: footerRightPrevPageRect.right
                anchors.leftMargin: parent.width * 0.01
                anchors.verticalCenter: parent.verticalCenter

                font.family: "HackRegular"
                font.pixelSize: footerRightPrevPageRect.height * 0.8
                color: themeData.colorTheme[theme].primary

                text: "Prev"

            }


            Rectangle {
                id: footerRightNextPageRect

                height: parent.height * 0.6
                width: height * 1.5
                anchors.left: footerRightPrevPageText.right
                anchors.leftMargin: parent.width * 0.02
                anchors.verticalCenter: parent.verticalCenter

                radius: 3

                color: themeData.colorTheme[themeSettings.theme].primary

                Text {
                    id: footerRightNextPageRectLetter

                    //anchors.left: footerLeftImage.right
                    //anchors.leftMargin: parent.width * 0.01
                    //anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter


                    font.family: "HackRegular"
                    font.pixelSize: parent.height * 0.8
                    font.bold: true
                    color: themeData.colorTheme[theme].background

                    text: "R1"
                }
            }

            Text {
                id: footerRightNextPageText

                anchors.left: footerRightNextPageRect.right
                anchors.leftMargin: parent.width * 0.01
                anchors.verticalCenter: parent.verticalCenter

                font.family: "HackRegular"
                font.pixelSize: footerRightNextPageRect.height * 0.8
                color: themeData.colorTheme[theme].primary

                text: "Next"

            }



            // Rectangle {
            //     id: footerRightPageUpRect

            //     height: parent.height * 0.6
            //     width: height * 1.5
            //     anchors.left: footerRightNextPageText.right
            //     anchors.leftMargin: parent.width * 0.02
            //     anchors.verticalCenter: parent.verticalCenter

            //     radius: 3

            //     color: themeData.colorTheme[themeSettings.theme].primary

            //     Text {
            //         id: footerRightPageUpRectLetter

            //         //anchors.left: footerLeftImage.right
            //         //anchors.leftMargin: parent.width * 0.01
            //         //anchors.fill: parent
            //         anchors.verticalCenter: parent.verticalCenter
            //         anchors.horizontalCenter: parent.horizontalCenter


            //         font.family: "HackRegular"
            //         font.pixelSize: parent.height * 0.8
            //         font.bold: true
            //         color: themeData.colorTheme[theme].background

            //         text: "L2"
            //     }
            // }

            // Text {
            //     id: footerRightPageUpText

            //     anchors.left: footerRightPageUpRect.right
            //     anchors.leftMargin: parent.width * 0.01
            //     anchors.verticalCenter: parent.verticalCenter

            //     font.family: "HackRegular"
            //     font.pixelSize: footerRightPageUpRect.height * 0.8
            //     color: themeData.colorTheme[theme].primary

            //     text: "Page Up"

            // }


            // Rectangle {
            //     id: footerRightPageDownRect

            //     height: parent.height * 0.6
            //     width: height * 1.5
            //     anchors.left: footerRightPageUpText.right
            //     anchors.leftMargin: parent.width * 0.02
            //     anchors.verticalCenter: parent.verticalCenter

            //     radius: 3

            //     color: themeData.colorTheme[themeSettings.theme].primary

            //     Text {
            //         id: footerRightPageDownRectLetter

            //         //anchors.left: footerLeftImage.right
            //         //anchors.leftMargin: parent.width * 0.01
            //         //anchors.fill: parent
            //         anchors.verticalCenter: parent.verticalCenter
            //         anchors.horizontalCenter: parent.horizontalCenter


            //         font.family: "HackRegular"
            //         font.pixelSize: parent.height * 0.8
            //         font.bold: true
            //         color: themeData.colorTheme[theme].background

            //         text: "R2"
            //     }
            // }

            // Text {
            //     id: footerRightPageDownText

            //     anchors.left: footerRightPageDownRect.right
            //     anchors.leftMargin: parent.width * 0.01
            //     anchors.verticalCenter: parent.verticalCenter

            //     font.family: "HackRegular"
            //     font.pixelSize: footerRightPageDownRect.height * 0.8
            //     color: themeData.colorTheme[theme].primary

            //     text: "Page Down"

            // }



        }


    }
}
