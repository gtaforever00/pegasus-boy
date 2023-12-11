import QtQuick 2.15
import QtGraphicalEffects 1.12

import "Components/Generic"
import "Components/Footer"

Item {

    property alias footerLeftText: footerLeftCounter.text

    Item {
        id: footerRoot

        height: parent.height * 0.8
        width: parent.width * 0.95
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: footerLeft

            height: parent.height
            
            anchors {
                left: parent.left
                leftMargin: parent.width * 0.01
            }

            color: themeData.colorTheme[theme].dark

            Component.onCompleted: {
                if (themeSettings.gamesListCounter) {
                    var gamesCount = api.allGames.count
                    var string = gamesCount + "/" + gamesCount
                    width = (utils.getTextWidth(string, footerLeftCounter.font, footerLeftCounter.fontSize) + height) * 1.10 
                }
                else {
                    width = 0
                    visible = false
                }
            }

            FooterCounter {
                id: footerLeftCounter
                anchors.fill: parent
                anchors.leftMargin: parent.width * 0.02
                text: ""
            }
            
        }

        Rectangle {
            id: footerMiddle

            height: parent.height
            //width: parent.width * 0.20
            width: footerMiddleClock.contentWidth * 1.5
            anchors.right: parent.right
            anchors.leftMargin: parent.width * 0.01


            color: themeData.colorTheme[themeSettings.theme].dark

           FooterTime {
                id: footerMiddleClock
                anchors {
                    fill: parent
                    leftMargin: (parent.width - contentWidth) / 2 
                }

           }
        }

        Rectangle {
            id: footerRight

            height: parent.height
            anchors.left: footerLeft.right
            anchors.leftMargin: parent.width * 0.01
            anchors.right: footerMiddle.left
            anchors.rightMargin: parent.width * 0.01

            color: themeData.colorTheme[themeSettings.theme].dark
            clip: true

            RoundButton {
                id: footerRightAcceptCircle

                height: parent.height * 0.6
                width: height
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: parent.width * 0.03
                }


                buttonColor: themeData.colorTheme[theme].primary
                textColor: themeData.colorTheme[theme].background
                text: "A"
                
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
        }
    }
}
