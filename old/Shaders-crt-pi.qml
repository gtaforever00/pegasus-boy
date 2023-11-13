import QtQuick 2.15

Item {

    //property real screenCurvature: appSettings.screenCurvature * appSettings.screenCurvatureSize
    // property real curvatureX: 0.10
    // property real curvatureY: 0.15
    property real curvatureX: 0.10
    property real curvatureY: 0.25

    property vector2d screenScale: Qt.vector2d(1.0, 1.0)
    property var source;

    ShaderEffect {
        id: shaderEffects

        blending: true
        anchors.fill: parent

        property variant source: effectSource

        property real curvatureX: parent.curvatureX
        property real curvatureY: parent.curvatureY
        property vector2d screenScale: parent.screenScale
        property vector2d sourceSize: Qt.vector2d(effectSource.textureSize.width, effectSource.textureSize.height) 
        property vector2d originalSize: Qt.vector2d(effectSource.sourceItem.width, effectSource.sourceItem.height)

        property real scanlineWeight: 6.0
        property real scanlineGapBrightnes: 0.12

        property real inputGamma: 2.4
        property real outputGamma: 2.2
        property real maskBrightness: 0.7
        property real maskSize: 1.0

        // vertexShader: "
        //     uniform highp mat4 qt_Matrix;
        //     attribute highp vec4 qt_Vertex;
        //     attribute highp vec2 qt_MultiTexCoord0;
        //     varying highp vec2 texCoord;

        //     void main() {
        //         texCoord = qt_MultiTexCoord0;
        //         gl_Position = qt_Matrix * qt_Vertex;
        //     }

        // "

        fragmentShader: "
            // uniform highp float screenCurvature;
            uniform sampler2D source;
            uniform vec4 qt_SubRect_source;
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            varying highp vec2 texCoord;

            uniform highp float curvatureX;
            uniform highp float curvatureY;
            uniform highp vec2 sourceSize;
            // uniform highp vec4 sourceSize2 = qt_SubRect_source;
            uniform highp vec2 originalSize;

            uniform lowp float scanlineWeight;
            uniform lowp float scanlineGapBrightnes;

            uniform lowp float scanlineDownscale;
            uniform lowp float inputGamma;
            uniform lowp float outputGamma;
            uniform lowp float maskBrightness;
            uniform lowp float maskSize;

            #ifdef GL_ES
                 precision mediump float;
            #endif


            uniform vec2 screenScale;

            vec4 scanlineWeights(float distance, vec4 color)
            {
                vec4 wid = 2.0 + 2.0 * pow(color, vec4(4.0));
                vec4 weights = vec4(distance / scanlineWeight);
                return 1.4 * exp(-pow(weights * inversesqrt(0.5 * wid), wid)) / (0.6 + 0.2 * wid);
            }

            float calcScanLineWeight(float dist)
            {
                return max(1.0-dist*dist*scanlineWeight, scanlineGapBrightnes);
            }

            float calcScanLine(float dy)
            {
                float scanWeight = calcScanLineWeight(dy);

                return scanWeight;
            }

            vec2 Distort(vec2 coord)
            {
                vec2 CURVATURE_DISTORTION = vec2(curvatureX, curvatureY);
                vec2 barrelScale = 1.0 - (0.23 * CURVATURE_DISTORTION);
                // coord *= screenScale;
                //coord *= sourceSize.xy / originalSize.xy;
                coord -= vec2(0.5);
                float rsq = coord.x * coord.x + coord.y * coord.y;
                coord += coord * (CURVATURE_DISTORTION * rsq);
                coord *= barrelScale;
                if (abs(coord.x) >= 0.5 || abs(coord.y) >= 0.5)
                {
                    coord = vec2(-1.0);
                }
                else
                {
                    coord += vec2(0.5);
                    //coord /= screenScale;
                }

                return coord;
            }

            void main()
            {
                // CRT curve
                lowp vec2 texcoord = Distort(qt_TexCoord0);
                if (texcoord.x < 0.0)
                    gl_FragColor = vec4(0.0);
                else
                {
                    vec2 texcoordInPixels = texcoord * sourceSize;

                    float tempY = floor(texcoordInPixels.y) + 0.5;
                    float yCoord = tempY / sourceSize.y;
                    float dy = texcoordInPixels.y - tempY;
                    float scanWeight = calcScanLine(dy);
                    float signY = sign(dy);
                    dy = dy * dy;
                    dy = dy * dy;
                    dy *= 8.0;
                    dy /= sourceSize.y;
                    dy *= signY;
                    vec2 tc = vec2(texcoord.x, yCoord + dy);

                    vec3 colour = texture2D(source, tc).rgb;

                    colour = pow(colour, vec3(inputGamma));
                    colour *= scanWeight;

                    colour = pow(colour, vec3(1.0/outputGamma));
                    gl_FragColor = vec4(colour, 1.0) * qt_Opacity;
                }



                //lowp vec4 tex = texture2D(source, coord);
                //gl_FragColor = tex;

            }"

        

        RootWindow {
            id: rootWindow
            anchors.fill: parent
        }

        ShaderEffectSource {
            id: effectSource
            sourceItem: rootWindow
            hideSource: true
            format: ShaderEffectSource.RGBA
            textureSize: Qt.size(rootWindow.width * 1, rootWindow.height * 1)
            live: true

        }
        
        onStatusChanged: {
             // Print warning messages
             if (log) console.log(log);
         }

         Component.onCompleted: {
            if (GraphicsInfo.shaderType === GraphicsInfo.GLSL)
                console.log("Shader Type: GLSL")
            if (GraphicsInfo.shaderType === GraphicsInfo.HSLS)
                console.log("Shader Type: HLSL")

            console.log("Source Size: " + sourceSize)
            console.log("Texture Size: " + originalSize)
         }

    }

}