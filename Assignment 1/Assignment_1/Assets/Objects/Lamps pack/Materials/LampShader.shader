/*
* Name: LampShader.shader
* Date: 08/09/2017
* Author: Michael Cartwright
* Version: 3.0
* Shader for Objects Lamp_1 and Lamp_2.
* Uses the FirstPass.cginc and SecondPass.cginc custom shaders
*/

Shader "LampShader"
{
	/*
	* Properties for user to change for Lamp_1 and Lamp_2
	* Pre: Default values selected
	* Post: Changes based of user interaction
	*/
	Properties
	{
		// main and normal map textures 
		_Tex1("Color Texture", 2D) = "black" {}
		_Tex2("Bump Map", 2D) = "bump" {}
		_BumpDepth("Bump Depth", Range(-2.0, 2.0)) = 1.0
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		// specular reflection
		_SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_ShineLevel("Shininess", Float) = 10
		// rim lighting effect
		_RimColor("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower("Rim Power", Range(0.1, 10.0)) = 3.0
	}

	/*
	* Subshader used for Lamp_1 and Lamp_2 in Assignment_1
	* Pre: First Pass begins
	* Post: Second Pass ends
	*/
	Subshader
	{
		/*
		* First Pass for directional light
		* Pre: Processes FirstPass.cginc
		* Post: Produces lighting effects for Lamp_1 and Lamp_2 from Sun directional light source using FirstPass.cginc custom shader
		*/
		Pass
		{
			// Directional light from Sun
			// No Cookie Attenuation for lightsource
			Tags{ "Lightmode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex VS_NormalMapping
			#pragma fragment PS_NormalMapping
			#include "Assets\Shaders\FirstPass.cginc"
			ENDCG
		}

		/*
		* Second Pass for spotlights in scene
		* Pre: Processes SecondPass.cginc
		* Post: Produces lighting effects for Lamp_1 and Lamp_2 from light sources Spotlight_1 and Spotlight_2 source using 
		*       SecondPass.cginc custom shader
		*/
		Pass
		{
			// For additional light sources
			Tags{ "Lightmode" = "ForwardAdd" }
			// Additive blending
			Blend One One
			CGPROGRAM
			#pragma vertex VS_NormalMapping
			#pragma fragment PS_NormalMapping
			#include "Assets\Shaders\SecondPass.cginc"
			ENDCG
		}
	}
}