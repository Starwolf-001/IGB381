/*
* Name: SplaterMap.cs
* Date: 27/10/2017
* Author: Michael Cartwright
* Version: 3.0
* Custom shader that is used in the first pass for the terrain.
* Designed to allow multiple textures to be applied to the terrain to provide a more
* realistic effect. From Dirt -> Grass -> Cliff -> Rocky Cliff is the goal.
*
* NOTE: On many attempts using different shaders and tutorials online, could not produce a method
*	    of placing textures across the terrain at different levels of height from the displacement
		map. Given up to attempt shadow casting and earn marks for other content.
*/

#include "UnityCG.cginc"

// Main Texture
sampler2D _Tex;
float4 _Tex_ST;
// Input Textures
sampler2D _Dirt;
sampler2D _Grass;
sampler2D _CliffDirt;
sampler2D _CliffRock;

/*
* Establishes a structure for the Vertex Shader Input
* Pre: Allows for position and texture coordinates
* Post: VSOutput
*/
struct VertexData {
	float4 position : POSITION;
	float2 tex : TEXCOORD0;
};

/*
* Establishes a structure for Interpolator postions, textures and the splat map
* Pre: Allows for position and texture coordinates
* Post: VSOutput
*/
struct Interpolators {
	float4 position : SV_POSITION;
	float2 tex : TEXCOORD0;
	float2 texSplat : TEXCOORD1;
};

/*
* Vertex and Interpolator shader
* Pre: Calculates for position and texture coordinates based in the Unity world
* Post: Returns VSOutput values
*/
Interpolators Vertex(VertexData vertex) {
	Interpolators i;
	i.position = mul(UNITY_MATRIX_MVP, vertex.position);
	i.tex = TRANSFORM_TEX(vertex.tex, _Tex);
	i.texSplat = vertex.tex;
	return i;
}

/*
* Pixel Shader for splat map by combining and blending textures together
* Pre: Combines the input textures together
* Post: A work in progress halted to attempt shadow casting
		[1] Need to blend textures together
		[2] Need to have textures applied to terrain based height_map
*/
float4 Fragment(Interpolators i) : SV_TARGET{
	float4 splat = tex2D(_Tex, i.texSplat);
	return tex2D(_Dirt, i.tex) * splat.r + tex2D(_Grass, i.tex) * splat.g + tex2D(_CliffDirt, i.tex) *
		   splat.b + tex2D(_CliffRock, i.tex) * (1 - splat.r - splat.g - splat.b);
}