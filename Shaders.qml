import QtQuick 2.15

Item {

    //property real screenCurvature: appSettings.screenCurvature * appSettings.screenCurvatureSize
    // property real curvatureX: 0.10
    // property real curvatureY: 0.15
    property real curvatureX: 0.10
    property real curvatureY: 0.20

    property vector2d screenScale: Qt.vector2d(1.0, 1.0)
    property var source;

    // required property RootWindow rootWindow;

    ShaderEffect {
        id: shaderEffects

        blending: false
        anchors.fill: parent

        property variant source: effectSource

        property real curvatureX: parent.curvatureX
        property real curvatureY: parent.curvatureY
        property vector2d screenScale: parent.screenScale
        property vector4d sourceSize: Qt.vector4d(effectSource.textureSize.width, effectSource.textureSize.height, 1.0 / effectSource.textureSize.width, 1.0 / effectSource.textureSize.height) 
        property vector4d originalSize: Qt.vector4d(effectSource.sourceItem.width, effectSource.sourceItem.height, 1.0 / effectSource.sourceItem.width, 1.0 / effectSource.sourceItem.height)
        property vector4d outputSize: Qt.vector4d(effectSource.width, effectSource.height, 1.0 / effectSource.width, 1.0 / effectSource.height)


        property real amp: 1.25
        property real phase: 0.5
        property real lines_black: 0.3
        property real lines_white: 1.0
        property real mask: 0.0
        property real mask_weight: 0.5
        //property real imageSize: 180.0
        property real imageSize: themeSettings.shaderScanlinesImageSize

        property real autoscale: 0

        property real curvature: 0.03

        // property real GLOW_FALLOFF: 0.35
        // property int TAPS: 4
        property real gammaInput: 2.4
        property real gammaOutput: 2.2





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

        fragmentShader: themeSettings.shaderEnable ? fragmentShaderString : ""

        property string fragmentShaderString: "
            // uniform highp float screenCurvature;
            uniform sampler2D source;
            uniform mediump vec4 qt_SubRect_source;
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            varying mediump vec2 texCoord;

            uniform mediump vec4 sourceSize;
            uniform mediump vec4 originalSize;
            uniform mediump vec4 outputSize;

            // varying mediump float omega;

            uniform lowp float amp;
            uniform lowp float phase;
            uniform lowp float lines_black;
            uniform lowp float lines_white;
            uniform lowp float mask;
            uniform lowp float mask_weight;
            uniform lowp float imageSize;
            uniform lowp float autoscale;\n" +

            (themeSettings.shaderCurvatureEnable ? "
            uniform lowp float curvature;
            uniform lowp float curvatureX;
            uniform lowp float curvatureY;
            " : "") +

            "
            #ifdef GL_ES
                 precision mediump float;
            #endif

            #define freq             0.500000
            #define offset           0.000000
            #define pi               3.141592654
            " +

            (themeSettings.shaderCurvatureEnable ? "
            vec2 Warp(vec2 pos)
            {
                pos = -1.0 + 2.0 * pos;
                vec2 p = pos * pos;
                
                pos *= vec2(1.0 + 1.3333 * curvature * p.y, 1.0 + curvature * p.x);
                return clamp(pos * 0.5 + 0.5, 0.0, 1.0);
            }


            vec2 Distort(vec2 coord)
            {
                vec2 CURVATURE_DISTORTION = vec2(curvatureX, curvatureY);
                vec2 barrelScale = 1.0 - (0.23 * CURVATURE_DISTORTION);

                coord -= vec2(0.5);
                float rsq = coord.x * coord.x + coord.y * coord.y;
                coord += coord * (CURVATURE_DISTORTION * rsq);
                coord *= barrelScale;
                if (abs(coord.x) >= 0.5 || abs(coord.y) >= 0.5)
                    coord = vec2(-1.0);
                else
                    coord += vec2(0.5);

                return coord;
            }
            " : "") +

            "
            void main()
            {
                float omega = 2.0 * pi * freq;
                vec2 texCoord = qt_TexCoord0;

                // Curve
                //vec2 curved_coords = warp(texCoord);
                // texCoord = Warp(texCoord);
                " +
                (themeSettings.shaderCurvatureEnable ? "
                texCoord = Distort(texCoord);
                if (texCoord.x < 0.0)
                {
                    gl_FragColor = vec4(0.0);
                    return;
                }
                " : "") +

                "
                vec3 color = texture2D(source, texCoord).rgb;

                
                " +

                (themeSettings.shaderScanlinesEnable ? "
                // Generate scanlines
                float scale = imageSize;
                //float angle = (qt_TexCoord0.y * originalSize.w) * omega * scale + phase;
                float angle = (qt_TexCoord0.y) * omega * scale + phase;

                float lines;
                lines = sin(angle);
                lines *= amp;
                lines += offset;
                lines = abs(lines);
                lines *= lines_white - lines_black;
                lines += lines_black;

                //color += color - clamp(blurHoriz(source, texCoord), 0.0, 0.5);
                //color += color - clamp(blurVert(source, texCoord), 0.0, 0.5);

                color += clamp(color * 0.4, 0.0, 0.5);

                color *= lines;
                " : "") +
                "

                //color += clamp(color * 0.4, 0.0, 0.5);
                //color *= vec3(1.3333);
                //color = clamp(color * )

                gl_FragColor = vec4(color.rgb, 1.0);

            }"

        

        RootWindow {
            id: rootWindow
            // width: Math.floor(parent.width/8)*8
            // //width: (parent.height * 3) / 4
            // //height: Math.floor(parent.height/8)*8
            // height: parent.width * 0.75
            // anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            Component.onCompleted: {
                // effectSource.textureSize = Qt.size(width, height)
                console.log("RootWindow loaded")
            }

            onWidthChanged: {
                console.log("RootWindow: " + rootWindow.width + ", " + rootWindow.height)
            }
            onHeightChanged: {
                console.log("RootWindow: " + rootWindow.width + ", " + rootWindow.height)
            }

        }

        ShaderEffectSource {
            id: effectSource

            // width: rootWindow.width
            // height: rootWindow.height
            // //width: Math.floor(parent.width / 8) * 8
            // //height: Math.floor(parent.height / 8) * 8
            // anchors.centerIn: parent

            sourceItem: rootWindow
            hideSource: true
            format: ShaderEffectSource.RGBA
            //textureSize: Qt.size(Math.floor(rootWindow.width / 8) * 8, Math.floor(rootWindow.height / 8) * 8)
            // textureSize: Qt.size(960, 540)
            textureSize: Qt.size(rootWindow.width, rootWindow.height)

            live: true



            Component.onCompleted: {
                console.log("Shader Texture Size: " + textureSize)
            }

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
            console.log("Output Size: " + outputSize)
         }

    }

}