Shader "LionShader"
{
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

	Subshader
	{
		// First Pass
		Pass
		{
			Tags{ "Lightmode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex VS_NormalMapping
			#pragma fragment PS_NormalMapping
			#include "Assets\Shaders\FirstPass.cginc"
			ENDCG
		}

		// Second Pass
		Pass
		{
			Tags{ "Lightmode" = "ForwardAdd" }
			Blend One One
			CGPROGRAM
			#pragma vertex VS_NormalMapping
			#pragma fragment PS_NormalMapping
			#include "Assets\Shaders\SecondPass.cginc"
			ENDCG
		}
	}
}