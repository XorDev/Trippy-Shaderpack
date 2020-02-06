#version 120

#define Color 1. //Rainbow intensity [.0 .2 .5 .8 1.]
#define Animation 0. //Animation speed [.0 .2 .5 .8 1.]
#define Spread .5 //Color Spread [.0 .2 .5 .8 1.]

uniform sampler2D texture;

uniform float frameTimeCounter;
uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec3 world;
varying vec2 coord0;

vec3 hash3(vec3 p)
{
    return fract(cos(p*mat3(-31.14,15.92,65.35,-89.79,-32.38,46.26,43.38,32.79,-02.88))*41.97);
}
vec3 value3(vec3 p)
{
    vec3 f = floor(p);
    vec3 s = p-f; s*= s*s*(3.-s-s);
    const vec2 o = vec2(0,1);
    return mix(mix(mix(hash3(f+o.xxx),hash3(f+o.yxx),s.x),
                   mix(hash3(f+o.xyx),hash3(f+o.yyx),s.x),s.y),
               mix(mix(hash3(f+o.xxy),hash3(f+o.yxy),s.x),
                   mix(hash3(f+o.xyy),hash3(f+o.yyy),s.x),s.y),s.z);
}
void main()
{
    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    vec4 tex = texture2D(texture,coord0);
    vec4 col = vec4(value3(world*.04*Spread)*8.+value3((world+world.zxy)*.1*Spread)*3.,0);
    col = mix(color * tex, color  * vec4(cos(tex.rgb*3.+col.rgb+frameTimeCounter*Animation)*.5+.5,tex.a), Color);
    col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog)*(1.-blindness);
    gl_FragData[0] = col;
}
