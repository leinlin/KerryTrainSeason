// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyShaderTrain/clip"
{
	Properties
	{
		_Float("Float 浮点数", Float) = 0.0
		_Cutout("_Cutout 浮点数", Range(-0.1, 1.1)) = 0.0
		_Range("Range", Range(0.0, 1.0)) = 0.0
		_Speed("速度", Vector) = (0,0,0,0)
		_Vector("Vector", Vector) = (1,1,1,1)
		_Color("Color", Color) = (0.5, 0.5, 0.5, 0.5)

		_MainTex("MainTex", 2D) = "bump" {}
		_NoiseTex("NoiseTex", 2D) = "bump" {}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", float) = 2

	}

	SubShader
	{
		Pass
		{
			Cull [_CullMode]
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
				float2 pos_uv : TEXCOORD1;
				// float3 normal : TEXCOORD1;
			};

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;

			float _Cutout;
			float4 _Speed;


			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				o.pos_uv = v.vertex.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				half gradient = tex2D(_MainTex, i.uv + _Time.y * _Speed.xy).r;
				half noise = tex2D(_NoiseTex, i.uv + _Time.y * _Speed.zw).r;
				clip(gradient - noise - _Cutout);
				return _Color;
				//return float4(i.uv, 0, 0);
				//return _Color;
			}

			ENDCG
		}
	}

}