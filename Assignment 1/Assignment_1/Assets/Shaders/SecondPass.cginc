#include "UnityCG.cginc"

// User defined variables
// Object textures
uniform sampler2D _Tex1;
uniform sampler2D _Tex2;
uniform float4 _Tex1_ST;
uniform float4 _Tex2_ST;
// Lighting
uniform float4 _Color;
uniform float4 _SpecColor;
uniform float4 _RimColor;
uniform float _ShineLevel;
uniform float _RimPower;
uniform float _BumpDepth;

// Unity light
uniform float4 _LightColor0;

// vertex shader input that allows position and texture coordinates as well as TBN
struct VSInput
{
	float4 pos: POSITION;
	float4 tang: TANGENT;
	float3 nor: NORMAL;
	float4 tex: TEXCOORD0;
};

// vertex shader output structure
struct VSOutput
{
	float4 pos: SV_POSITION;
	float4 tex: TEXCOORD0;
	float4 posWorld: TEXCOORD1;
	float3 normWorld: TEXCOORD2;
	float3 tangWorld: TEXCOORD3;
	float3 binoWorld: TEXCOORD4;
};

// vertex shader
VSOutput VS_NormalMapping(VSInput a_Input)
{
	VSOutput output;

	output.normWorld = normalize(mul(float4(a_Input.nor, 0.0), unity_WorldToObject).xyz);
	output.tangWorld = normalize(mul(unity_WorldToObject, a_Input.tang).xyz);
	output.binoWorld = normalize(cross(output.normWorld, output.tangWorld) * a_Input.tang.w);

	output.posWorld = mul(unity_ObjectToWorld, a_Input.pos);
	output.pos = mul(UNITY_MATRIX_MVP, a_Input.pos);
	output.tex = a_Input.tex;

	return output;
}

// pixel shader
half4 PS_NormalMapping(VSOutput a_Input) : COLOR
{
	// calculate vector to camera
	float3 cameraDirection = normalize(_WorldSpaceCameraPos.xyz - a_Input.posWorld.xyz);
	float3 lightDirection;
	float atten;

	// directional light
	if (_WorldSpaceLightPos0.w == 0.0)
	{
		atten = 1.0;
		lightDirection = normalize(_WorldSpaceLightPos0.xyz);
	}
	else
	{
		float3 fragToLightSource = _WorldSpaceLightPos0.xyz - a_Input.posWorld.xyz;
		float distance = length(fragToLightSource);
		atten = 1.0 / distance;
		lightDirection = normalize(fragToLightSource);
	}

	// texture maps
	float4 normal = tex2D(_Tex2, a_Input.tex.xy * _Tex2_ST.xy + _Tex2_ST.zw);

	// unpack normal
	float3 localCoords = float3(2.0 * normal.ag - float2(1.0, 1.0), 0.0);
	localCoords.z = _BumpDepth;

	// normal transpose matrix
	float3x3 local2WorldTranspose = float3x3(a_Input.tangWorld, a_Input.binoWorld, a_Input.normWorld);

	// calculate normal direction
	float3 normalDirection = normalize(mul(localCoords, local2WorldTranspose));

	// diffuse and specular lighting reflections
	float3 diffuseRef = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
	float3 specRef = diffuseRef * _SpecColor.xyz * pow(saturate(dot(reflect(-lightDirection, normalDirection), cameraDirection)), _ShineLevel);

	// rim lighting effect
	float rim = 0.75 - saturate(dot(cameraDirection, normalDirection));
	float3 rimLighting = saturate(dot(normalDirection, lightDirection) * _RimColor.xyz * _LightColor0.xyz * pow(rim, _RimPower));

	// lighting
	float3 lightFinal = diffuseRef + specRef + rimLighting;
	return float4(lightFinal * _Color.xyz, 1.0);
}