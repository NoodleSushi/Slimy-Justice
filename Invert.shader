shader_type canvas_item;

void fragment(){
	vec4 va = texture(TEXTURE,UV);
	COLOR = vec4(vec3(1.0,1.0,1.0)-va.rgb,va.a);
}