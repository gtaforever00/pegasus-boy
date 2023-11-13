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

        blending: false
        anchors.fill: parent

        property variant source: effectSource

        property real curvatureX: parent.curvatureX
        property real curvatureY: parent.curvatureY
        property vector2d screenScale: parent.screenScale
        property vector2d sourceSize: Qt.vector2d(effectSource.textureSize.width, effectSource.textureSize.height) 
        property vector2d originalSize: Qt.vector2d(effectSource.sourceItem.width, effectSource.sourceItem.height)

        property real blurScaleX: 0.30
        property real lowLumScan: 6.0
        property real hiLumScan: 8.0
        property real brightBoost: 1.25
        property real maskDark: 0.25
        property real maskFade: 0.8
        property real curve: 0.03
        property real corner: 0.3


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
            uniform lowp vec4 qt_SubRect_source;
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            varying highp vec2 texCoord;

            uniform highp float curvatureX;
            uniform highp float curvatureY;
            uniform highp vec2 sourceSize;
            // uniform highp vec4 sourceSize2 = qt_SubRect_source;
            uniform highp vec2 originalSize;

            uniform lowp float curve;
            uniform lowp float corner;
            uniform lowp float blurScaleX;
            uniform lowp float lowLumScan;
            uniform lowp float hiLumScan;
            uniform lowp float brightBoost;
            uniform lowp float maskDark;
            uniform lowp float maskFade;


            #ifdef GL_ES
                 precision mediump float;
            #endif


            uniform vec2 screenScale;

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

            vec2 warp(vec2 pos)
            {
                pos = -1.0 + 2.0 * pos;
                vec2 p = pos * pos;

                pos *= vec2(1.0 + 1.3333 * curve * p.y, 1.0 + curve * p.x);
                return clamp(pos * 0.5 + 0.5, 0.0, 1.0);
            }

            // vec2 barrel(vec2 v, vec2 cc)
            // {
            //     float distortion = dot(cc, cc) * screenCurvature;
            //     return (v - cc * (1.0 + distortion) * distortion);
            // }

            void main()
            {
                vec2 invDims = 1.0 / sourceSize;
                //vec2 texcoord = qt_TexCoord0;
                // CRT curve
                vec2 texcoord = Distort(qt_TexCoord0);
                
                //vec2 texcoord = warp(tex);
                if (texcoord.x < 0.0)
                {
                    gl_FragColor = vec4(0.0);
                    return;
                }
                

                    vec2 p = texcoord * sourceSize;
                    vec2 i = floor(p) + 0.50;
                    vec2 f = p - i;
                    p = (i + 4.0 * f * f * f) * invDims;
                    p.x = mix(p.x, texcoord.x, blurScaleX);
                    float Y = f.y * f.y;
                    float YY = Y*Y;

                    float whichmask = floor(qt_SubRect_source.x * originalSize.x) * -0.3333;
                    //float whichmask = floor(qt_SubRect_source.x * sourceSize.x) * -0.3333;

                    float mask = 1.0 + float(fract(whichmask) < 0.3333) * -maskDark;

                    vec3 colour = texture2D(source, p).rgb;

                    float scanLineWeight = (brightBoost - lowLumScan * (Y - 2.05*YY));
                    float scanLineWeightB = 1.0 - hiLumScan * (YY - 2.8 * YY * Y);

                    //vec3 texColour = colour.rgb * mix(scanLineWeight * mask, scanLineWeightB, dot(colour.rgb, vec3(maskFade)));
                    //gl_FragColor = texture2D(source, texColour);

                    vec2 corn = min(texcoord, vec2(1.0) - texcoord);
                    corn.x = (corner * 0.0001) / corn.x;
                    if (corn.y <= corn.x)
                        colour = vec3(0.0);
                    
                    gl_FragColor.rgba = vec4(colour.rgb * mix(scanLineWeight * mask, scanLineWeightB, dot(colour.rgb, vec3(0.3333 * maskFade))), 1.0);



                //lowp vec4 tex = texture2D(source, coord);
                //gl_FragColor = tex;

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
            textureSize: Qt.size(960, 540)

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
         }

    }

}