shader_type canvas_item;
uniform sampler2D Paper;
uniform float PaperBleed;
uniform float Clamp;
uniform float lod;
void fragment(){
	vec2 pix = 1.0/vec2(textureSize(Paper,0));
	vec4 orig = texture(Paper,SCREEN_UV)-texture(Paper,SCREEN_UV+vec2(0,pix.y));
	float neg = (orig.r+orig.b+orig.g)/3.0;
	
	vec4 colorout = textureLod ( SCREEN_TEXTURE,SCREEN_UV+neg*(PaperBleed/100.0), lod );
	if ((colorout.r+colorout.g+colorout.b)/3.0 > Clamp/100.0){
		colorout = vec4(1.0,1.0,1.0,1.0)
	}
	COLOR = colorout*texture(Paper,SCREEN_UV);
}