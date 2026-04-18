// custom texture bombing/splatting
float4 result = float4(0, 0, 0, 0);

float splats = 1*density;

float2 seed = float2(123.456, 789.012);

float2 scaleRange = float2(1,3) * scale;
float2 rotationRange = float2(0, 360);
float2 offsetRange = float2(-1, 1);

for(int i = 0; i < splats; i++)
{
    seed = frac(seed * 123.456);

    float randScale = lerp(scaleRange.x, scaleRange.y, seed.x);
    float randRotation = radians(lerp(rotationRange.x, rotationRange.y, seed.y));
    float randOffset = lerp(offsetRange.x, offsetRange.y, seed);

    float2x2 rotationMatrix = float2x2(cos(randRotation), -sin(randRotation),
                                       sin(randRotation), cos(randRotation));

    float2 uvResult = mul(rotationMatrix, (uv * randScale) + randOffset);

    float4 sampledColor = Texture2DSample(inputTex, inputTexSampler, uvResult);
    sampledColor = float4(sampledColor.x*sampledColor.a,
                   sampledColor.g*sampledColor.a,
                   sampledColor.b*sampledColor.a,
                   sampledColor.a);
    result += sampledColor;
}

result = pow(result, contrast);
result /= (splats/brightness);
return result;
