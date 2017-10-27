/*
* Name: SplaterMap.cs
* Date: 25/10/2017
* Author: Michael Cartwright
* Version: 1.2
* Custom shader that is used in the first pass for the terrain.
* Designed to allow multiple textures to be applied to the terrain to provide a more
* realistic effect. From Dirt -> Grass -> Cliff -> Rocky Cliff is the goal.
*
* This shader does not work
*/

#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_ST;

sampler2D _Texture1;
sampler2D _Texture2;
sampler2D _Texture3;
sampler2D _Texture4;

struct VertexData {
	float4 position : POSITION;
	float2 uv : TEXCOORD0;
};

struct Interpolators {
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD0;
	float2 uvSplat : TEXCOORD1;
};

Interpolators MyVertexProgram(VertexData vertex) {
	Interpolators i;
	i.position = mul(UNITY_MATRIX_MVP, v.position);
	i.uv = TRANSFORM_TEX(vertex.uv, _MainTex);
	i.uvSplat = vertex.uv;
	return i;
}

float4 MyFragmentProgram(Interpolators i) : SV_TARGET{
	float4 splat = tex2D(_MainTex, i.uvSplat);
	return tex2D(_Texture1, i.uv) * splat.r + tex2D(_Texture2, i.uv) * splat.g + tex2D(_Texture3, i.uv) * 
		   splat.b + tex2D(_Texture4, i.uv) * (1 - splat.r - splat.g - splat.b);
}