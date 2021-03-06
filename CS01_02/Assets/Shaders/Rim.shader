// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShaderTrain/AlphaBlend"
{
	Properties
	{
		_Float("Float 浮点数", Float) = 0.0
		_Emiss("_Emiss", Float) = 1.0
		_Range("Range", Range(0.0, 1.0)) = 0.0
		_Vector("Vector", Vector) = (1,1,1,1)
		_MainColor("_MainColor", Color) = (0.5, 0.5, 0.5, 0.5)
		_MainTex("MainTex", 2D) = "bump" {}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", float) = 2
	}

	SubShader
	{
		Tags{"Queue" = "Transparent"}
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
				// float3 normal : NORMAL;
				// float4 color  : COLOR;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv  : TEXCOORD0;
				// float3 normal : TEXCOORD1;
			};

			float4 _MainColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Emiss;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				half3 col = _MainColor.rgb;
				half alpha = saturate(tex2D(_MainTex, i.uv).r * _MainColor.a *  _Emiss);

				return float4(col, alpha);
				//return _Color;
			}

			ENDCG
		}
	}

}