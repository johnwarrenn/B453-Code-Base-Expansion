shader_type canvas_item;

// Makes character more white
// pls don't sue me for whitewashing, kai wanted this.
uniform float whiteness = 0;

void fragment() {
	float alpha = texture(TEXTURE, UV).a;
	float red = texture(TEXTURE, UV).r;
	float green = texture(TEXTURE, UV).g;
	float blue = texture(TEXTURE, UV).b;
	COLOR.r = whiteness + (1.0 - whiteness)*red;
	COLOR.g = whiteness + (1.0 - whiteness)*green;
	COLOR.b = whiteness + (1.0 - whiteness)*blue;
	COLOR.a = alpha;
}