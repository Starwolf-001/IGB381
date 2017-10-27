/*
* Name: LightandShadowShader.shader
* Date: 27/10/2017
* Author: Michael Cartwright
* Version: 5.0
* Shader for ThirdPersonCharacter Ethan
* Uses the FirstPass.cginc, SecondPass.cginc and ShadowPass.cginc custom shaders
*/

Shader "LightandShadowShader"
{
	/*
	* Properties for user to change for GameObjects
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
	* Subshader used for Ethan in Assignment_1
	* Pre: First Pass begins
	* Post: Second Pass ends
	*/
	Subshader
	{
		/*
		* First Pass for directional light
		* Pre: Processes FirstPass.cginc
		* Post: Produces lighting effects for a GameObject from the Sun directional light source using FirstPass.cginc custom shader
		*/
		Pass
		{
			// Directional light from Sun
			// No Cookie Attenuation for lightsource
			Tags{ "Lightmode" = "ForwardBase" }
			CGPROGRAM
			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON
			#pragma vertex VS_NormalMapping
			#pragma fragment PS_NormalMapping
			#include "Assets\Shaders\FirstPass.cginc"
			ENDCG
		}

		/*
		* Second Pass for spotlights in scene
		* Pre: Processes SecondPass.cginc
		* Post: Produces lighting effects for a gameObject from SpotLight sources
		*/
		Pass
		{
			// For additional light sources
			Tags{ "Lightmode" = "ForwardAdd" }
			// Additive blending
			Blend One One
			CGPROGRAM
			// For Receiving Shadows
			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON

			#pragma vertex VS_NormalMapping
			#pragma fragment PS_NormalMapping
			#include "Assets\Shaders\SecondPass.cginc"
			ENDCG
		}

		/*
		* Shadow Pass for shadows to be cast
		* Pre: All lightning effects completed
		* Post: Casts a shadow from the GameObject
		*/
		Pass
		{
			// For shadows to be cast
			Tags{ "Lightmode" = "ShadowCaster" }
			CGPROGRAM
			#pragma vertex ShadowVertex
			#pragma fragment ShadowFragment
			#include "Assets\Shaders\ShadowPass.cginc"
			ENDCG
		}
	}
}