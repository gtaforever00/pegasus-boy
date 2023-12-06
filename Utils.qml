import QtQuick 2.15

import "Logger.js" as Logger

Item {

    TextMetrics {
        id: calculateFontSizeMetrics
    }

    function calculateFontSizeModel(font, width, height, model, minSize = 8, maxSize = 72) {
        //property int fontSize = calculateFontSizeMetrics.font.pixelSize;
        // Minimum size
        var size = maxSize;
        calculateFontSizeMetrics.font = font;
        // console.log("The width of e:" + width);
        // console.log("The height of e: " + height)
        model.forEach((item) => {
            var fSize;
            calculateFontSizeMetrics.font.pixelSize = height;
            calculateFontSizeMetrics.text = item;
            var brect = calculateFontSizeMetrics.boundingRect;
            // console.log("brect width: " + brect.width);
            // console.log("brect height: " + brect.height);
            if (brect.width > width) {
                var k = width / brect.width;
                fSize = Math.floor(calculateFontSizeMetrics.font.pixelSize * k);
            }
            else {
                fSize = calculateFontSizeMetrics.font.pixelSize;
            }

            if (fSize < size) {
                size = fSize;
            }
        });
        
        return size;
    }

    function getTextWidth(text, font, size) {
        calculateFontSizeMetrics.font = font;
        calculateFontSizeMetrics.font.pixelSize = size;
        calculateFontSizeMetrics.text = text;

        return calculateFontSizeMetrics.width;
    }

    function generateRangeModel(min, max, step=1) {
        var model = [];
        // var count = (max - min) / step
        for (let i = min; i <= max; i+= step) {
            model.push(i);
        }
        return model;
    }

    function findIndexByValue(array, value) {
        //var f = Array(array);
        Logger.debug("Utils:findIndexByValue:array:" + array);
        Logger.debug("Utils:findIndexbyValue:value:" + value);
        var index = array.indexOf(value);
        Logger.debug("Utils:findIndexByValue:index:" + index);
        return index;
    }

    function getModelByValue(model, criteria) {
        for(var i=0; i < model.count; ++i) {
            if (criteria(model.get(i))) { return model.get(i) }
        }
        return null
    }
    
    function findModelIndex(model, criteria) {
        Logger.info("Utils:findModelIndex:model:" + model);
        for(var i=0; i < model.count; ++i) {
            if (criteria(model.get(i))) { return i }
        }
        Logger.info("Utils:findModelIndex:NoMatch");
        return 0
    }

    Component.onCompleted: {
        // var logger = Logger;
        Logger.LOG_PRIORITY = Logger.DEBUG;
        Logger.info("Utils:onCompleted:Logger:" + Logger.LOG_PRIORITY);
    }


}
