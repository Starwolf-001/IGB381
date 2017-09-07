Shader "LampShader" 
{
 	Properties 
 	{
		_Tex1("Base (RGB)", 2D) = "black" {}    
		_Tex2("Bumpmap", 2D) = "bump" {} 
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shine("Shine", Float) = 10
		_RimColor("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower("Rim Power", Range(0.1, 10.0)) = 3.0
	}	
    
    SubShader 
	{
  		Pass 
  		{ 
			Tags { "Lightmode" = "ForwardBase" }
			CGPROGRAM
			
	        #pragma vertex VS_NormalMapping 
	        #pragma fragment PS_NormalMapping
	        #pragma target 3.0
	        
			#include "UnityCG.cginc"
			
			// used to transform vertices from local space into homogenous clipping space
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shine;
			uniform float _RimPower;
			uniform sampler2D _Tex1;
			uniform float4 _Tex1_ST;
			uniform sampler2D _Tex2;

			// Unity light
			uniform float4 _LightColor0;
			
			// light direction in world space
			static float3 _vecCameraPos 	= {0.0f, 0.0f, -5.0f};	// camera position (in world space)
			static float  _fSpecPower 		= 10.0f;				// specular power

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
				output.pos = mul(UNITY_MATRIX_MVP, a_Input.pos);
			
				// copy texture coordinates across
				output.tex = a_Input.tex;

				// WIT transform the normal and tangent
				a_Input.nor = normalize(mul(transpose(unity_WorldToObject), float4(a_Input.nor, 1.0f))).xyz;
				a_Input.tang = normalize(mul(transpose(unity_WorldToObject), a_Input.tang));
				
				// calculate binormal
				bin = cross(a_Input.tang.xyz, a_Input.nor);
			
				// calculate matrix to tangent space
				float3x3 toTangentSpace = transpose(float3x3(a_Input.tang.xyz, bin, a_Input.nor));
			
				output.lightDir = -1 * mul(toTangentSpace, g_lightDir);
				
				// calculate world vertex position
				output.posWorld = mul(unity_ObjectToWorld, a_Input.pos).xyz;
			
				return output;
			}

			// normal mapping pixel shader
			half4 PS_NormalMapping(VSOutput a_Input) : COLOR
			{
				// calculate vector to camera
				float3 toCamera = normalize(_vecCameraPos.xyz - a_Input.posWorld.xyz);
			
				// normalize light direction
				float3 light = normalize(a_Input.lightDir);

				float3 currentLightSourceDirection;
				float atten;

				if(_WorldSpaceLightPos0.w == 0.0)
				{
					atten = 1.0;
					currentLightSourceDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else 
				{
					float3 normalMappingToLightSource = _WorldSpaceLightPos0.xyz - a_Input.posWorld.xyz;
					float distance = length(normalMappingToLightSource);
					atten = 1.0 / distance;
					currentLightSourceDirection = normalize(normalMappingToLightSource);
				}

				// Lighting
				float3 diffuse = atten * _LightColor0.xyz * saturate(dot(light, currentLightSourceDirection));
				float3 specComp = diffuse * _SpecColor.xyz * pow(saturate(dot(reflect(-currentLightSourceDirection, light), toCamera)), _Shine);
				
				// Rim Lighting
				float rim = 0.75 - saturate(dot(toCamera, light));
				float3 rimLighting = saturate(dot(light, currentLightSourceDirection) * _RimColor.xyz * _LightColor0.xyz * pow(rim, _RimPower));

				float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuse + specComp + rimLighting;

				// index into textures
				float4 tex = tex2D(_Tex1, a_Input.tex.xy * _Tex1_ST.xy + _Tex1_ST.zw);
				float3 normal = UnpackNormal(tex2D(_Tex2, a_Input.tex)).rgb;

				return float4(tex.xyz * lightFinal * _Color.xyz, 1.0);
			}			
			ENDCG
		}

		Pass 
  		{ 
			Tags { "Lightmode" = "ForwardAdd" }
			Blend One One
			CGPROGRAM
			
	        #pragma vertex VS_NormalMapping 
	        #pragma fragment PS_NormalMapping
	        #pragma target 3.0
	        
			#include "UnityCG.cginc"
			
			// used to transform vertices from local space into homogenous clipping space
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shine;
			uniform float _RimPower;
			uniform sampler2D _Tex1;
			uniform float4 _Tex1_ST;
			uniform sampler2D _Tex2;

			// Unity light
			uniform float4 _LightColor0;
			
			// light direction in world space
			static float3 _vecCameraPos 	= {0.0f, 0.0f, -5.0f};	// camera position (in world space)
			static float  _fSpecPower 		= 10.0f;				// specular power

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
				output.pos = mul(UNITY_MATRIX_MVP, a_Input.pos);
			
				// copy texture coordinates across
				output.tex = a_Input.tex;

				// WIT transform the normal and tangent
				a_Input.nor = normalize(mul(transpose(unity_WorldToObject), float4(a_Input.nor, 1.0f))).xyz;
				a_Input.tang = normalize(mul(transpose(unity_WorldToObject), a_Input.tang));
				
				// calculate binormal
				bin = cross(a_Input.tang.xyz, a_Input.nor);
			
				// calculate matrix to tangent space
				float3x3 toTangentSpace = transpose(float3x3(a_Input.tang.xyz, bin, a_Input.nor));
			
				output.lightDir = -1 * mul(toTangentSpace, g_lightDir);
				
				// calculate world vertex position
				output.posWorld = mul(unity_ObjectToWorld, a_Input.pos).xyz;
			
				return output;
			}

			// normal mapping pixel shader
			half4 PS_NormalMapping(VSOutput a_Input) : COLOR
			{
				// calculate vector to camera
				float3 toCamera = normalize(_vecCameraPos.xyz - a_Input.posWorld.xyz);
			
				// normalize light direction
				float3 light = normalize(a_Input.lightDir);

				float3 currentLightSourceDirection;
				float atten;

				if(_WorldSpaceLightPos0.w == 0.0)
				{
					atten = 1.0;
					currentLightSourceDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else 
				{
					float3 normalMappingToLightSource = _WorldSpaceLightPos0.xyz - a_Input.posWorld.xyz;
					float distance = length(normalMappingToLightSource);
					atten = 1.0 / distance;
					currentLightSourceDirection = normalize(normalMappingToLightSource);
				}

				// Lighting
				float3 diffuse = atten * _LightColor0.xyz * saturate(dot(light, currentLightSourceDirection));
				float3 specComp = diffuse * _SpecColor.xyz * pow(saturate(dot(reflect(-currentLightSourceDirection, light), toCamera)), _Shine);
				
				// Rim Lighting
				float rim = 0.75 - saturate(dot(toCamera, light));
				float3 rimLighting = saturate(dot(light, currentLightSourceDirection) * _RimColor.xyz * _LightColor0.xyz * pow(rim, _RimPower));

				float3 lightFinal = diffuse + specComp + rimLighting;

				// index into textures
				float4 tex = tex2D(_Tex1, a_Input.tex.xy * _Tex1_ST.xy + _Tex1_ST.zw);
				float3 normal = UnpackNormal(tex2D(_Tex2, a_Input.tex)).rgb;

				return float4(lightFinal * _Color.xyz, 1.0);
			}			
			ENDCG
		}
	}
}