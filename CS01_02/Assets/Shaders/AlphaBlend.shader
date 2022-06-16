// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShaderTrain/Rim"
{
	Properties
	{
		_Float("Float 浮点数", Float) = 0.0
		_Emiss("_Emiss", Float) = 1.0
		_RimPower("_RimPower", Float) = 1.0
		_Range("Range", Range(0.0, 1.0)) = 0.0
		_Vector("Vector", Vector) = (1,1,1,1)
		_MainColor("_MainColor", Color) = (0.5, 0.5, 0.5, 0.5)
		_MainTex("MainTex", 2D) = "bump" {}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", float) = 2
	}

	SubShader
	{
		Tags{"Queue" = "Transparent"}
		Pass {
			Cull Off
			ZWrite On
			ColorMask 0
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			float4 vert(float4 vertexPos : POSITION) : SV_POSITION
			{
				return UnityObjectToClipPos(vertexPos);
			}
			
			float4 frag(void) : COLOR
			{
				return float4(0,0,0,0);
			}

			ENDCG
		}

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull [_CullMode]
			ZWrite Off
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
				float3 normal : NORMAL;
				// float4 color  : COLOR;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv  : TEXCOORD0;
				float3 normal_world : TEXCOORD1;
				float3 view_world : TEXCOORD2;
			};

			float4 _MainColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Emiss;
			float _RimPower;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

				o.normal_world = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz);
				float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.view_world = normalize(_WorldSpaceCameraPos.xyz - pos_world);
				
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float3 normal_world = normalize(i.normal_world);
				float3 view_world = normalize(i.view_world);
				float NdotV = saturate(dot(normal_world, view_world));
				float3 col = _MainColor.xyz * _Emiss;
				float fresnel = pow(1.0 - NdotV, _RimPower);
				float alpha = saturate(fresnel * _Emiss);

				return float4(col, alpha);
			}

			ENDCG
		}
	}

}