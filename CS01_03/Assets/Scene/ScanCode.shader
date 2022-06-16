Shader "Unlit/ScanCode"
{
    Properties
    {
        // rim
        _MinRim("MinRim", float) = 0
        _MaxRim("MaxRim", float) = 1
        _TexPower("TexPower", float) = 1
        _InnerColor("InnerColor", Color) = (0, 0, 0, 0)
        _RimColor("RimColor", Color) = (0, 0, 0, 0)
        _RimIntensity("RimIntensity", float) = 1
        _MainTex ("MainTex", 2D) = "white" {}

        // flow
        _FlowTex("FlowTex", 2D) = "white" {}
        _FlowTiling("FlowTiling", Vector) = (0, 0, 0, 0)
        _FlowSpeed("FlowSpeed", Vector) = (0, 0, 0, 0)
        _FlowIntensity("FlowIntensity", float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal_world : TEXCOORD1;
                float3 view_world : TEXCOORD2;
                float3 flow_pos : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _MinRim;
            float _MaxRim;
            float _TexPower;
            float _RimIntensity;
            float4 _InnerColor;
            float4 _RimColor;

            sampler2D _FlowTex;
            float4 _FlowTiling;
            float4 _FlowSpeed;
            float _FlowIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal_world = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz);

                o.uv = v.uv;
                float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 zero_pos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;

                o.view_world = normalize(_WorldSpaceCameraPos.xyz - pos_world);
                o.flow_pos = pos_world - zero_pos;


                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 mainColor = pow(tex2D(_MainTex, i.uv), _TexPower);
                float3 flow_pos = normalize(i.flow_pos.xyz);
                float3 view_world = normalize(i.view_world.xyz);
                float3 normal_world = normalize(i.normal_world.xyz);
                float NdotV = saturate(dot(normal_world, view_world));
                float finalRimAlpha = saturate(smoothstep(_MinRim, _MaxRim, 1 - NdotV) + mainColor.r);
                float3 finalRimColor = lerp(_InnerColor, (_RimColor * _RimIntensity), finalRimAlpha).rgb;

                float4 flowColor = tex2D(_FlowTex, i.flow_pos * _FlowTiling + _Time.y * _FlowSpeed) * _FlowIntensity;



                return float4(finalRimColor + flowColor.rgb, saturate(finalRimAlpha + flowColor.a));
            }
            ENDCG
        }
    }
}
