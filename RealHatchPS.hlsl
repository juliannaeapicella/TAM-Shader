#include "ShaderHelper.hlsli"
Texture2D albedo             :  register(t0); // "t" registers 
Texture2D normalMap          :  register(t1);
Texture2D TAM1               :  register(t2);
Texture2D TAM2               :  register(t3);
SamplerState samplerOptions  :  register(s0); // "s" registers 
cbuffer ExternalData : register(b0)
{
	DirectionalLight light;
	float3 ambientColor;
	float3 cameraPosition;
	int silhouetteID;
}

float4 main(VertexToPixelRealHatch input) : SV_TARGET
{
	// calculate normals
	input.normal = normalize(input.normal);
	input.tangent = normalize(input.tangent);
	float3 N = input.normal;
	float3 T = input.tangent;
	T = normalize(T - N * dot(T, N)); // Gram-Schmidt orthogonalization 
	float3 B = cross(T, N);
	float3x3 TBN = float3x3(T, B, N);

	float3 unpackedNormal = normalMap.Sample(samplerOptions, input.uv).rgb * 2 - 1;

	input.normal = mul(unpackedNormal, TBN);
	input.normal = normalize(input.normal);

	float3 lightDirNormal = normalize(light.direction);

	// calculate diffuse lighting
	float factor = (dot(input.normal, lightDirNormal) + 1.0f) * 3.0f; // change range to 0,6

	// calculate weights for TAM
	float3 TAMWeight1 = float3( 1.0f - saturate(abs(factor - 5.0f)),
								1.0f - saturate(abs(factor - 4.0f)),
								1.0f - saturate(abs(factor - 3.0f)));
	float3 TAMWeight2 = float3( 1.0f - saturate(abs(factor - 2.0f)),
								1.0f - saturate(abs(factor - 1.0f)),
								1.0f - saturate(abs(factor)));

	// get TAM values
	float3 TAM1Sample = pow(TAM1.Sample(samplerOptions, input.uv).rgb, 2.2f);
	float3 TAM2Sample = pow(TAM2.Sample(samplerOptions, input.uv).rgb, 2.2f);

	// weight texture results to get shaded look
	float3 surfaceColor = saturate(GetInverseColor(
		saturate(dot(GetInverseColor(TAM1Sample), TAMWeight1)) +
		saturate(dot(GetInverseColor(TAM2Sample), TAMWeight2))));

	float3 finalColor = surfaceColor + (ambientColor * surfaceColor);

	return float4(pow(finalColor, 1.0f / 2.2f), silhouetteID / 256.0f);
}