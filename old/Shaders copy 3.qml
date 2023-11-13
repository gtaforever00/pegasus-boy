import QtQuick 2.15

Item {

    //property real screenCurvature: appSettings.screenCurvature * appSettings.screenCurvatureSize
    // property real curvatureX: 0.10
    // property real curvatureY: 0.15
    property real curvatureX: 0.10
    property real curvatureY: 0.20

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
        property vector4d sourceSize: Qt.vector4d(effectSource.textureSize.width, effectSource.textureSize.height, 1.0 / effectSource.textureSize.width, 1.0 / effectSource.textureSize.height) 
        property vector4d originalSize: Qt.vector4d(effectSource.sourceItem.width, effectSource.sourceItem.height, 1.0 / effectSource.sourceItem.width, 1.0 / effectSource.sourceItem.height)
        property vector4d outputSize: Qt.vector4d(effectSource.width, effectSource.height, 1.0 / effectSource.width, 1.0 / effectSource.height)


        property real amp: 1.25
        property real phase: 0.5
        property real lines_black: 0.5
        property real lines_white: 1.0
        property real mask: 0.0
        property real mask_weight: 0.5
        property real imageSize: 224.0
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

        fragmentShader: "
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
            uniform lowp float autoscale;

            uniform lowp float curvature;
            uniform lowp float curvatureX;
            uniform lowp float curvatureY;

            // uniform lowp float GLOW_FALLOFF;
            // uniform int TAPS;
            // uniform lowp float GAMMA_INPUT;
            uniform lowp float gammaInput;
            uniform lowp float gammaOutput;


            #ifdef GL_ES
                 precision mediump float;
            #endif

            #define freq             0.500000
            #define offset           0.000000
            #define pi               3.141592654

            //#define GLOW_FALLOFF 0.35
            //#define TAPS 4
            #define GLOW_FALLOFF 0.35
            #define TAPS 4

            #define kernel(x) exp(-GLOW_FALLOFF * (x) * (x))

            // vec2 barrel(vec2 v, vec2 cc)
            // {
            //     float distortion = dot(cc, cc) * screenCurvature;
            //     return (v - cc * (1.0 + distortion) * distortion);
            // }

            // 

            vec2 Warp(vec2 pos)
            {
                pos = -1.0 + 2.0 * pos;
                vec2 p = pos * pos;
                
                pos *= vec2(1.0 + 1.3333 * curvature * p.y, 1.0 + curvature * p.x);
                return clamp(pos * 0.5 + 0.5, 0.0, 1.0);
            }

            vec2 CURVATURE_DISTORTION = vec2(curvatureX, curvatureY);
            vec2 barrelScale = 1.0 - (0.23 * CURVATURE_DISTORTION);

            vec2 Distort(vec2 coord)
            {
                
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

            vec4 delinearize(in sampler2D color, vec2 coord)
            {
                return pow(vec4(texture2D(color, coord).rgb, 1.0), vec4(1.0 / 2.2));
            }

            vec4 linearize(in sampler2D color, vec2 coord)
            {
                return pow(vec4(texture2D(color, coord).rgb, 1.0), vec4(2.2));
            }

            vec3 downsample(sampler2D tex, vec2 coord, vec2 off)
            {
                vec3 color = texture2D(tex, coord - off).rgb;
                color += texture2D(tex, coord + vec2(off.x, -off.y)).rgb;
                color += texture2D(tex, coord + off).rgb * vec3(4.0);
                color += texture2D(tex, coord + off).rgb;
                color +=texture2D(tex, coord - vec2(off.x, -off.y)).rgb;
                color *= vec3(0.125);

                return color;
            }


            vec3 upsample(in sampler2D tex, in vec2 coord, in vec2 off)
            {

                vec3 color = texture2D(tex, coord + vec2(0.0, -off.y * 2.0)).rgb;

                vec3 color2 = texture2D(tex, coord + vec2(-off.x, -off.y)).rgb;
                color2 += texture2D(tex, coord + vec2(off.x, -off.y)).rgb;
                color2 *= vec3(2.0);

                color += color2;
                color += texture2D(tex, coord + vec2(-off.x * 2.0, 0.0)).rgb;
                color += texture2D(tex, coord + vec2(off.x * 2.0, 0.0)).rgb;

                vec3 color3 = texture2D(tex, coord + vec2(-off.x, off.y)).rgb;
                color3 += texture2D(tex, coord + vec2(off.x, off.y)).rgb;
                color3 *= vec3(2.0);

                color += color3;
                color += texture2D(tex, coord + vec2(0.0, off.y * 2.0)).rgb;

                color \= vec3(12.0);

                return color;                          
            }

            vec3 blurHoriz(sampler2D tex, vec2 coord)
            {
                vec3 col = vec3(0.0);
                float dx = 4.0 * sourceSize.z;

                float k_total = 0.0;
                for (int i = -TAPS; i <= TAPS; i++)
                {
                    float k = kernel(i);
                    k_total += k;
                    col += k * texture2D(tex, coord + vec2(float(i) * dx, 0.0)).rgb;
                }

                return vec3(col / k_total);
            }

            vec3 blurVert(sampler2D tex, vec2 coord)
            {
                vec3 col = vec3(0.0);
                float dy = sourceSize.w;

                float k_total = 0.0;
                for (int i = -TAPS; i <= TAPS; i++)
                {
                    float k = kernel(i);
                    k_total += k;
                    col += k * texture2D(tex, coord + vec2(0.0, float(i) * dy)).rgb;
                }

                return vec3(col / k_total);
            }

            void main()
            {
                float omega = 2.0 * pi * freq;
                vec2 texCoord = qt_TexCoord0;

                // Curve
                //vec2 curved_coords = warp(texCoord);
                // texCoord = Warp(texCoord);

                texCoord = Distort(texCoord);
                if (texCoord.x < 0.0)
                {
                    gl_FragColor = vec4(0.0);
                    return;
                }

                vec3 color = texture2D(source, texCoord).rgb;

                

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

                color *= lines;

                color += clamp(color * 0.3, 0.0, 0.5);

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