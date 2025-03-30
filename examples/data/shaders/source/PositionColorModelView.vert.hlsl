cbuffer uniforms : register(b0, space1)
{
    row_major float4x4 proj_view : packoffset(c0);
    row_major float4x4 model : packoffset(c4);
};

struct Input
{
    float3 position : TEXCOORD0;
    float4 color : TEXCOORD1;
};

struct Output
{
    float4 color : TEXCOORD0;
    float4 position : SV_Position;
};

Output main(Input input)
{
    Output output;
    output.color = input.color;
    output.position = mul(float4(input.position, 1.0f), mul(model, proj_view));
    return output;
}