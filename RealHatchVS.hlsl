#include "ShaderHelper.hlsli"
cbuffer ExternalData : register(b0)
{
	matrix world;
	matrix view;
	matrix proj;
}

VertexToPixelRealHatch main(VertexShaderInput input)
{
	// Set up output struct
	VertexToPixelRealHatch output;

	matrix wvp = mul(proj, mul(view, world));
	output.position = mul(wvp, float4(input.position, 1.0f));
	output.normal = mul((float3x3)world, input.normal);
	output.uv = input.uv;
	output.tangent = mul((float3x3)world, input.tangent);
	output.worldPos = mul((float3x3)world, input.position);

	// Whatever we return will make its way through the pipeline to the
	// next programmable stage we're using (the pixel shader for now)
	return output;
}