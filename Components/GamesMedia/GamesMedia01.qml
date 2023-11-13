import QtQuick 2.15
import QtGraphicalEffects 1.12


Item {

    required property var currentGame

    Image {
        id: gamesMediaScreenshot

        width: parent.width * 0.8
        height: parent.height * 0.5

        anchors {
            top: parent.top
            //bottom: parent.bottom
            //left: parent.left
            right: parent.right
            rightMargin: parent.width * 0.02
            left: parent.left
            leftMargin: parent.width * 0.02
        }

        asynchronous: true
        fillMode: Image.PreserveAspectFit
        sourceSize {
            width: width
            height: height
        }

        source: currentGame.assets.screenshots[0] || ""
    }

    Item {
        id: gamesMediaTextBlockRoot

        anchors.top: gamesMediaScreenshot.bottom
        anchors.topMargin: root.height * 0.02
        anchors.left: parent.left
        anchors.leftMargin: root.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: root.width * 0.02
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02

        Item {
            id: gamesMediaTextBlock

            width: parent.width
            height: parent.height * 0.6
            anchors.verticalCenter: parent.verticalCenter

            Item {
                id: gamesMediaGenre

                height: parent.height * 0.5
                width: parent.width * 0.5

                Text {
                    id: gamesMediaGenreTitle
                    height: parent.height * 0.5
                    width: parent.width

                    font.family: "HackRegular"
                    font.bold: true
                    font.pixelSize: height * 0.6
                    color: themeData.colorTheme[theme].primary
                    text: "Genre"
                }

                Text {
                    id: gamesMediaGenreText

                    height: parent.height * 0.5
                    width: parent.width
                    anchors.top: gamesMediaGenreTitle.bottom

                    font.family: "HackRegular"
                    font.pixelSize: height * 0.6
                    elide: Text.ElideRight
                    color: themeData.colorTheme[theme].primary
                    text: currentGame.genre
                }

            }


            Item {
                id: gamesMediaDeveloper

                anchors.top: gamesMediaGenre.bottom
                height: parent.height * 0.5
                width: parent.width * 0.5

                Text {
                    id: gamesMediaDeveloperTitle
                    height: parent.height * 0.5
                    width: parent.width

                    font.family: "HackRegular"
                    font.bold: true
                    font.pixelSize: height * 0.6
                    color: themeData.colorTheme[theme].primary
                    text: "Devoloper"
                }

                Text {
                    id: gamesMediaDeveloperText

                    height: parent.height * 0.5
                    width: parent.width
                    anchors.top: gamesMediaDeveloperTitle.bottom

                    font.family: "HackRegular"
                    font.pixelSize: height * 0.6
                    elide: Text.ElideRight
                    color: themeData.colorTheme[theme].primary
                    text: currentGame.developer
                }

            }

            Item {
                id: gamesMediaRating

                anchors.top: parent.top
                anchors.left: gamesMediaGenre.right
                anchors.leftMargin: parent.width * 0.02
                height: parent.height * 0.5
                width: parent.width * 0.5


                Text {
                    id: gamesMediaRatingTitle
                    height: parent.height * 0.5
                    width: parent.width

                    font.family: "HackRegular"
                    font.bold: true
                    font.pixelSize: height * 0.6
                    color: themeData.colorTheme[theme].primary
                    text: "Rating"
                }


                Rectangle {
                    id: gamesMediaRatingRect
                    anchors.top: gamesMediaRatingTitle.bottom
                    //height: parent.height * 0.5
                    height: parent.height * 0.3
                    //width: gamesMediaRatingStar.width
                    width: parent.width * 0.5 * currentGame.rating

                    color: themeData.colorTheme[theme].primary
                    visible: false

                }

                Image {
                    id: gamesMediaRatingStar

                    anchors.top: gamesMediaRatingTitle.bottom
                    //height: parent.height * 0.5
                    height: parent.height * 0.3
                    width: {
                        if (currentGame.rating == 0) {
                            return height * 5
                        } 
                        else {
                            height * 5 * currentGame.rating
                        }
                    }

                    source: "../../assets/star_empty.svg"
                    sourceSize {
                        width: height
                        height: height
                    }
                    smooth: true
                    fillMode: Image.TileHorizontally
                    horizontalAlignment: Image.AlignLeft
                    visible: false

                }

                OpacityMask {
                    id: gamesMediaRatingText

                    anchors.fill: gamesMediaRatingStar
                    source: gamesMediaRatingRect
                    maskSource: gamesMediaRatingStar
                }

            }

            Item {
                id: gamesMediaReleaseDate

                height: parent.height * 0.5
                width: parent.width * 0.5

                anchors.top: gamesMediaRating.bottom
                anchors.left: gamesMediaDeveloper.right
                anchors.leftMargin: parent.width * 0.02                        

                Text {
                    id: gamesMediaReleaseDateTitle
                    height: parent.height * 0.5
                    width: parent.width

                    font.family: "HackRegular"
                    font.bold: true
                    font.pixelSize: height * 0.6
                    color: themeData.colorTheme[theme].primary
                    text: "Released"
                }

                Text {
                    id: gamesMediaReleaseDateText

                    height: parent.height * 0.5
                    width: parent.width
                    anchors.top: gamesMediaReleaseDateTitle.bottom

                    font.family: "HackRegular"
                    font.pixelSize: height * 0.6
                    elide: Text.ElideRight
                    color: themeData.colorTheme[theme].primary
                    visible: currentGame.releaseYear != 0
                    text: {
                        var month = currentGame.releaseMonth.toString()
                        var day = currentGame.releaseDay.toString()
                        var year = currentGame.releaseYear.toString()
                        if (month.toString().length == 1) {
                            month = "0" + month
                        }
                        if (day.toString().length == 1) {
                            day = "0" + day
                        }
                        
                        
                        return month + "/" + day + "/" + year
                    }
                }

            }



        }




        // Text {
        //     id: gamesMediaDeveloper

        //     anchors.top: gamesMediaGenre.bottom
        //     height: parent.height * 0.5
        //     width: parent.width * 0.5

        //     font.family: "HackRegular"
        //     color: themeData.colorTheme[theme].primary
        //     text: "Developer: " + currentGame.developer

        // }

    }


}