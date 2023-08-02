shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// WRITTEN BY CHATGPT

// Uniform variable for the threshold value (0.0 to 1.0)
uniform float threshold : hint_range(0.0, 1.0) = 0.5;

// The dithering texture
uniform sampler2D dither_texture;

void vertex() {
    // Pass the vertex position to the fragment shader
    // Since we're not modifying the vertex, this function can be empty
}

void fragment() {
    // Get the grayscale value of the pixel
    float grayscale = 0.2126 * texture(SCREEN_TEXTURE, SCREEN_UV).r + 0.7152 * texture(SCREEN_TEXTURE, SCREEN_UV).g + 0.0722 * texture(SCREEN_TEXTURE, SCREEN_UV).b;

    // Scale the grayscale value to match the number of tones required
    float scaledValue = grayscale * 15.99;

    // Calculate the dither offset based on the current pixel's position
    vec2 ditherOffset = vec2(mod(FRAGCOORD.x, 4.0), mod(FRAGCOORD.y, 4.0));

    // Sample the dither texture to get the dither matrix value
    float ditherValue = texture(dither_texture, ditherOffset / 4.0).r;

    // Calculate the final dithered grayscale value
    float ditheredGrayscale = (scaledValue + ditherValue) / 16.0;

    // Convert the dithered grayscale color to a 1-bit color based on the threshold
    vec3 color = step(threshold, vec3(ditheredGrayscale));

    // Output the final color (1-bit black or white)
    COLOR = vec4(color, 1.0);
}
