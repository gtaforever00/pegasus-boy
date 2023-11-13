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

        property real thickness: 0.01
        property real glow: 0.0
        property real sGamma: 2.40
        property real tGamma: 2.40
        property real highlights: 0.75
        property real boost: 0.0


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

        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;

            varying vec2 vTexCoord;
            varying float thickness;
            varying float glow;
            varying float highlights;
            varying float boost;

            void main()
            {
                gl_Position = qt_Matrix * qt_Vertex;
                vTexCoord = qt_MultiTexCoord0;
                thickness = 0.5 + mix(0.0, 2.0, thickness);
                glow = mix(-0.5, 0.5, glow);
                highlights = mix(0.0, 1.0, highlights);
                boost = mix(0.0, 5.0, boost);

            }
    
        "

        fragmentShader: "
            #define pi 3.141592654
            #define luminance(c) (0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b)
            
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


            uniform float sGamma;
            uniform float tGamma;
            varying vec2 vTexCoord;
            varying float thickness;
            varying float glow;
            varying float highlights;
            varying float boost;

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

            vec3 gammaFn(vec3 c, float gamma)
            {
                return vec3(pow(c.x, gamma), pow(c.y, gamma), pow(c.z, gamma));
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

                    vec2 uv = vTexCoord.xy;
                    vec3 col = texture2D(source, uv).rgb;
                    col = gammaFn(col, sGamma);
                    float L = luminance(col);
                    float y = fract(uv.y * originalSize.y * 1.0);

                    y = pow(sin(y * pi), thickness);
                    y = (y + glow) / (1.0 + glow);
                    float g = 1.0 + L * (1.0 - L) * boost;
                    col = mix(col, col * g * y, 1.0 - L * highlights);

                    gl_FragColor = vec4(gammaFn(col, 1.0 / tGamma), 1.0);
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
             textureSize: Qt.size(rootWindow.width * 1, rootWindow.height * 1)
            // textureSize: Qt.size(640, 480)

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