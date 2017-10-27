﻿/*
* Name: TerrainShader.shader
* Date: 25/10/2017
* Author: Michael Cartwright
* Version: 1.2
* Shader for terrain
* Uses the FirstPass.cginc, SecondPass.cginc and ShadowPass.cginc custom shaders
*/

Shader "TerrainShader"
{
	/*
	* Properties for user to change for Terrain
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
	* Subshader used for Terrain in Assignment_2
	* Pre: First Pass begins
	* Post: Second Pass ends
	*/
	Subshader
	{
		/*
		* First Pass for directional light
		* Pre: Processes FirstPass.cginc
		* Post: Produces lighting effects
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
			// Splat map does not work
			//#include "Assets\Shaders\SplatterMap.cginc"
			#include "Assets\Shaders\FirstPass.cginc"
			ENDCG
		}

		/*
		* Second Pass for spotlights in scene
		* Pre: Processes SecondPass.cginc
		* Post: Produces lighting effects
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

		/*
		* Shadow Pass for shadows to be cast
		* Pre: All lightning effects completed
		* Post: Produces shadow of object
		*/
		Pass
		{
			// For shadowes to be casted
			Tags{ "Lightmode" = "ShadowCaster" }
			CGPROGRAM
			#pragma vertex ShadowVertex
			#pragma fragment ShadowFragment
			#include "Assets\Shaders\ShadowPass.cginc"
			ENDCG
		}
	}
}