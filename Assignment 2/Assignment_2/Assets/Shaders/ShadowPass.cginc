/*
* Name: ShadowPass.cs
* Date: 27/10/2017
* Author: Michael Cartwright
* Version: 1.2
* Custom shader that allows for shadows to be projected
* To be called from third Pass
*/

#include "UnityCG.cginc"

/*
* Establishes a structure for the Vertex Shader Input
* Pre: Allows for position and texture coordinates
* Post: VSOutput
*/
struct VertexInput
{
	float4 position : POSITION;
	float normal : NORMAL;
};

/*
* Vertex shader for shadows
* Pre: Calculates for position and texture coordinates based in the Unity world
* Post: Returns VSOutput values
*/
float4 ShadowVertex(VertexInput vertex) : SV_POSITION
{
	// Cast Shadows from GameObject
	float4 clippedPos;
	float3 inputVertex = vertex.position.xyz;
	if (unity_LightShadowBias.z != 0.0) {
		float3 wPosition = mul(unity_ObjectToWorld, float4(inputVertex, 1)).xyz;
		float3 wNormal = UnityObjectToWorldNormal(vertex.normal);
		float3 wLight = normalize(UnityWorldSpaceLightDir(wPosition));

		float cosine = dot(wNormal, wLight);
		float sine = sqrt(1 - cosine * cosine);
		float normalBias = unity_LightShadowBias.z * sine;

		wPosition -= wNormal * normalBias;

		clippedPos = mul(UNITY_MATRIX_VP, float4(wPosition, 1));
	}
	else {
		clippedPos = UnityObjectToClipPos(inputVertex);
	}
	return UnityApplyLinearShadowBias(clippedPos);
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

	