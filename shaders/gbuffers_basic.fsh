#version 120

uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;

void main()
{
    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    vec4 col = color * vec4(vec3(1.-blindness),1);
    col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);
    gl_FragData[0] = col;
}
