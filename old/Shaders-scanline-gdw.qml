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

        property real beam: 3.0
        property real scanline: 1.35

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
            //Line1
            #define PI 3.141592654

            #define BEAM2 beam*1.5
            #define SCANLINE2 scanline*0.7

            #define SourceSize2 vec4(sourceSize, 1.0 / sourceSize)
            
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


            uniform float beam;
            uniform float scanline;

            #ifdef GL_ES
                 precision mediump float;
            #endif

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

            float sw(float y, float l)
            {
                float scan = mix(beam, BEAM2, y);
                float tmp = mix(scanline, SCANLINE2, 1.0);
                float ex = y * tmp;
                return exp2(-scan * ex * ex);
            }


            void main()
            {
                // CRT curve
                //lowp vec2 texcoord = Distort(qt_TexCoord0);
                // vec2 texcoord = Distort(qt_TexCoord0);
                // if (texcoord.x < 0.0)
                //     gl_FragColor = vec4(0.0);
                // else
                // {


                    // thickness = 0.5 + mix(0.0, 2.0, thickness);
                    // glow = mix(-0.5, 0.5, glow);
                    // highlights = mix(0.0, 1.0, highlights);
                    // boost = mix(0.0, 5.0, boost);
                vec2 pC4 = qt_TexCoord0;
                vec3 res1 = texture2D(source, pC4).rgb;
                vec3 res2 = texture2D(source, pC4 + vec2(0.0, SourceSize2.w)).rgb;

                float lum = dot(vec3(0.3, 0.6, 0.1), res1);
                float y = fract(pC4.y * SourceSize2.y);
                vec3 res = res1 * sw(y, lum) + res2 * sw(1.0 - y, lum);
                


                gl_FragColor = vec4(res, 1.0);
                // }



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
            //  textureSize: Qt.size(rootWindow.width * 1, rootWindow.height * 1)
            textureSize: Qt.size(640, 480)

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