// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "NormalMapping" 
{
 	Properties 
 	{
		_Tex1("Base (RGB)", 2D) = "black" {}    
		_Tex2("Bumpmap", 2D) = "bump" {} 
	}	
    
    SubShader 
	{
  		Pass 
  		{ 
			CGPROGRAM
			
	        #pragma vertex VS_NormalMapping 
	        #pragma fragment PS_NormalMapping
	        #pragma target 3.0
	        
			#include "UnityCG.cginc"
			
			// used to transform vertices from local space into homogenous clipping space
			sampler2D _Tex1;
			sampler2D _Tex2;
			
			// light direction in world space
			static float3 _vecCameraPos 	= {0.0f, 0.0f, -5.0f};	// camera position (in world space)
			static float  _fSpecPower 		= 10.0f;					// specular power

			// vertex shader input that allows position and texture coordinates as well as TBN
			struct VSInput 
			{
				float4 pos: POSITION;
				float4 tang: TANGENT;
				float3 nor: NORMAL;
				float2 tex: TEXCOORD0;
			};
			
			// vertex shader output structure
			struct VSOutput 
			{
				float4 pos: SV_POSITION;
				float2 tex: TEXCOORD0;
				float3 lightDir: TEXCOORD1;
				float3 posWorld	: TEXCOORD2;
			};
			
			// normal mapping vertex shader
			VSOutput VS_NormalMapping(VSInput a_Input) 
			{
				VSOutput output;
				float3 bin;
				float3 g_lightDir = {5.0f, 5.0f, -5.0f};
				
				// calculate homogenous position
				output.pos = UnityObjectToClipPos(a_Input.pos);
			
				// copy texture coordinates across
				output.tex = a_Input.tex;
				
				// WIT transform the normal and tangent
				a_Input.nor = normalize(mul(transpose(unity_WorldToObject), float4(a_Input.nor, 1.0f))).xyz;
				a_Input.tang = normalize(mul(transpose(unity_WorldToObject), a_Input.tang));
				
				// calculate binormal
				bin = cross(a_Input.tang.xyz, a_Input.nor);
			
				// calculate matrix to tangent space
				float3x3 toTangentSpace = transpose(float3x3(a_Input.tang.xyz, bin, a_Input.nor));
			
				output.lightDir = mul(toTangentSpace, g_lightDir);
				
				// calculate world vertex position
				output.posWorld = mul(unity_ObjectToWorld, a_Input.pos).xyz;
			
				return output;
			}

			// normal mapping pixel shader
			float4 PS_NormalMapping(VSOutput a_Input) : COLOR
			{
				// index into textures
				float4 colour = tex2D(_Tex1, a_Input.tex);
				float3 normal = UnpackNormal(tex2D(_Tex2, a_Input.tex)).rgb;
			
				// calculate vector to camera
				float3 toCamera = normalize(_vecCameraPos.xyz - a_Input.posWorld.xyz);
			
				// normalize light direction
				float3 light = normalize(a_Input.lightDir);

				// calculate reflection vector
				float3 reflectVec = reflect(light, normal);
			
				// calculate diffuse component, max to prevent back lighting
				float diffuse = max(dot(normal, light), 0.0f);

				// calculate specular variable
				float specComp = pow(max(dot(reflectVec, toCamera), 0.0f), _fSpecPower);
			
				colour = colour + diffuse * 0.05 + specComp * 0.5;
				colour.a = 1;
			
				// return texture colour modified by diffuse component
				return colour;
			}
						
			ENDCG
		}
	} 
}