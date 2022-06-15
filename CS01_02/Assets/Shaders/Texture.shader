// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShaderTrain/Texture"
{
	Properties
	{
		_Float("Float 浮点数", Float) = 0.0
		_Range("Range", Range(0.0, 1.0)) = 0.0
		_Vector("Vector", Vector) = (1,1,1,1)
		_Color("Color", Color) = (0.5, 0.5, 0.5, 0.5)
		_MainTex("MainTex", 2D) = "bump" {}

	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
				// float3 normal : NORMAL;
				// float4 color  : COLOR;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv  : TEXCOORD0;
				// float3 normal : TEXCOORD1;
			};

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				return tex2D(_MainTex, i.uv);
				//return _Color;
			}

			ENDCG
		}
	}

}