import QtQuick 2.15

import "../../Logger.js" as Logger

Item {

    required property var visibleArea;

    Rectangle {
        id: scrollbar

        width: parent.width

        height: {
            var h = parent.height * visibleArea.heightRatio;
            if (h < parent.height * 0.1) { h = parent.height * 0.1 }
            Logger.debug("Scrollbar:height:" + h);
            return h;
        }


        color: themeData.colorTheme[theme].primary

        // adding .01 to the height fixes a bug where the scrollbar would show
        // if the games matched the rows equally
        visible: height + 0.01 < parent.height

        y: {
            // scale scrollbar based on height of scrollbar
            var ratio = (height / parent.height) - visibleArea.heightRatio;
            var posY = (visibleArea.yPosition * (1 - ratio)) * parent.height;
            Logger.debug("Scrollbar:y:" + posY);
            return posY;
        }

        Component.onCompleted: {
            Logger.debug("Scrollbar:parent:height:" + parent.height);
            Logger.debug("Scrollbar:visibleArea:heightRatio:" + visibleArea.heightRatio);
        }

    }

}
