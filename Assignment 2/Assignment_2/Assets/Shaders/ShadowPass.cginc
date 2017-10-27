/*
* Name: ShadowPass.cs
* Date: 26/10/2017
* Author: Michael Cartwright
* Version: 1.0
* Custom shader that allows for shadows to be projected
*/

#include "UnityCG.cginc"

/*
* Establishes a structure for the Vertex Shader Input
* Pre: Allows for position and texture coordinates
* Post: VSOutput
*/
struct VertexInput
{
	float4 position: POSITION;
};

/*
* Vertex shader for shadows
* Pre: Calculates for position and texture coordinates based in the Unity world
* Post: Returns VSOutput values
*/
float4 ShadowVertex(VertexInput vertex) : SV_POSITION
{
	float4 position = mul(UNITY_MATRIX_MVP, vertex.position);
	return UnityApplyLinearShadowBias(position);
}

/*
* 
* Pre: ShadowVertex calculates shadow bias
* Post: returns 0 for the fragment
*/
half4 ShadowFragment() : SV_TARGET 
{
	return 0;
}

	