// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Scan 1"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_MinRim("MinRim", Range( -1 , 2)) = 0
		_MaxRim("MaxRim", Range( 0 , 2)) = 0
		_RimColor("RimColor", Color) = (0,0,0,0)
		_InnerColor("InnerColor", Color) = (0,0,0,0)
		_RimIntensity("RimIntensity", Float) = 1
		_FlowEmiss("FlowEmiss", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		_FlowIntensity("FlowIntensity", Float) = 0.5
		_TexPower("TexPower", Float) = 1
		_InnerAlpha("InnerAlpha", Float) = 0
		_FlowTilling("FlowTilling", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
		};

		uniform float4 _InnerColor;
		uniform float4 _RimColor;
		uniform float _RimIntensity;
		uniform sampler2D _MainTex;
		SamplerState sampler_MainTex;
		uniform float4 _MainTex_ST;
		uniform float _TexPower;
		uniform float _MinRim;
		uniform float _MaxRim;
		uniform sampler2D _FlowEmiss;
		uniform float2 _FlowTilling;
		uniform float2 _Speed;
		uniform float _FlowIntensity;
		uniform float _InnerAlpha;
		SamplerState sampler_FlowEmiss;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldNormal = i.worldNormal;
			float dotResult8 = dot( ase_worldNormal , i.viewDir );
			float smoothstepResult17 = smoothstep( _MinRim , _MaxRim , ( 1.0 - saturate( dotResult8 ) ));
			float FinalRimAlpha60 = saturate( ( pow( tex2D( _MainTex, uv_MainTex ).r , _TexPower ) + smoothstepResult17 ) );
			float4 lerpResult24 = lerp( _InnerColor , ( _RimColor * _RimIntensity ) , FinalRimAlpha60);
			float4 FinalRimColor58 = lerpResult24;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float2 appendResult36 = (float2(ase_vertex3Pos.x , ase_vertex3Pos.y));
			float4 transform67 = mul(unity_ObjectToWorld,float4(0,0,0,0));
			float2 appendResult69 = (float2(transform67.x , transform67.y));
			float4 tex2DNode28 = tex2D( _FlowEmiss, ( ( ( appendResult36 - appendResult69 ) * _FlowTilling ) + ( _Speed * _Time.y ) ) );
			float4 FlowColor53 = ( tex2DNode28 * _FlowIntensity );
			o.Emission = ( FinalRimColor58 + FlowColor53 ).rgb;
			float FlowAlpha55 = ( tex2DNode28.a * _FlowIntensity );
			o.Alpha = saturate( ( FinalRimAlpha60 + _InnerAlpha + FlowAlpha55 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1372;304;1310;654;2603.4;-2012.709;1.744393;True;True
Node;AmplifyShaderEditor.CommentaryNode;64;-1612.36,1037.494;Inherit;False;1863.892;824.4736;RimAlpha;14;7;6;8;10;20;9;1;47;18;46;17;49;60;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;6;-1562.36,1255.077;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-1525.659,1448.054;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;57;-1776.49,2106.181;Inherit;False;2269.937;560.8904;扫光;18;37;30;32;36;51;33;52;31;28;45;44;55;42;53;66;67;69;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;66;-1749.861,2444.994;Inherit;False;Constant;_Vector0;Vector 0;13;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;8;-1281.671,1335.325;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;37;-1768.29,2148.427;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;10;-1266.47,1580.302;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;67;-1579.583,2464.049;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-1033.414,1323.109;Inherit;False;Property;_TexPower;TexPower;10;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1204.934,1087.494;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;False;-1;be8f19aec22965b418fd04de4f9f5f25;be8f19aec22965b418fd04de4f9f5f25;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-1025.675,1745.968;Inherit;False;Property;_MaxRim;MaxRim;3;0;Create;True;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1012.416,1564.591;Inherit;False;Property;_MinRim;MinRim;2;0;Create;True;0;0;False;0;False;0;0;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1500.87,2308.634;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;9;-975.2705,1442.502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;36;-1548.534,2161.344;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;51;-1337.822,2395.405;Inherit;False;Property;_FlowTilling;FlowTilling;12;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;17;-607.6672,1450.9;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;30;-1167.446,2372.355;Inherit;False;Property;_Speed;Speed;8;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1173.127,2545.953;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;46;-846.9865,1152.594;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-1389.106,2154.301;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1210.863,2189.081;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-553.6501,1294.579;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-920.163,2392.699;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;48;-368.0933,1489.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;65;-1610.487,284.5556;Inherit;False;1083.66;717.3858;RimColor;7;23;25;26;61;22;24;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-700.5867,2222.938;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;28;-591.5675,2401.741;Inherit;True;Property;_FlowEmiss;FlowEmiss;7;0;Create;True;0;0;False;0;False;-1;adc10745c1b069148b3531cbd4dcab6a;adc10745c1b069148b3531cbd4dcab6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-276.5727,2382.722;Inherit;False;Property;_FlowIntensity;FlowIntensity;9;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1543.216,712.9799;Inherit;False;Property;_RimIntensity;RimIntensity;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1560.487,514.9991;Inherit;False;Property;_RimColor;RimColor;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;27.53086,1469.726;Inherit;False;FinalRimAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;51.77583,2532.071;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1311.639,582.2453;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-1333.893,334.5555;Inherit;False;Property;_InnerColor;InnerColor;5;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1142.54,809.9418;Inherit;False;60;FinalRimAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;269.4464,2542.221;Inherit;False;FlowAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-107.9941,2156.181;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;24;-957.4957,640.4006;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;1403.536,648.5284;Inherit;False;55;FlowAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;56.24481,2273.986;Inherit;False;FlowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1316.897,560.0479;Inherit;False;Property;_InnerAlpha;InnerAlpha;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;1390.616,460.0264;Inherit;False;60;FinalRimAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-750.8265,670.3259;Inherit;False;FinalRimColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;1515.959,92.30112;Inherit;False;58;FinalRimColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;1751.729,493.7094;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;1547.338,273.9532;Inherit;False;53;FlowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2;2171.774,129.6317;Inherit;False;305;497;c;1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;1902.697,200.0493;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;41;1892.572,412.2374;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2221.775,179.6316;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Scan 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;10;0;8;0
WireConnection;67;0;66;0
WireConnection;69;0;67;1
WireConnection;69;1;67;2
WireConnection;9;0;10;0
WireConnection;36;0;37;1
WireConnection;36;1;37;2
WireConnection;17;0;9;0
WireConnection;17;1;18;0
WireConnection;17;2;20;0
WireConnection;46;0;1;1
WireConnection;46;1;47;0
WireConnection;70;0;36;0
WireConnection;70;1;69;0
WireConnection;52;0;70;0
WireConnection;52;1;51;0
WireConnection;49;0;46;0
WireConnection;49;1;17;0
WireConnection;33;0;30;0
WireConnection;33;1;32;0
WireConnection;48;0;49;0
WireConnection;31;0;52;0
WireConnection;31;1;33;0
WireConnection;28;1;31;0
WireConnection;60;0;48;0
WireConnection;44;0;28;4
WireConnection;44;1;45;0
WireConnection;26;0;23;0
WireConnection;26;1;25;0
WireConnection;55;0;44;0
WireConnection;42;0;28;0
WireConnection;42;1;45;0
WireConnection;24;0;22;0
WireConnection;24;1;26;0
WireConnection;24;2;61;0
WireConnection;53;0;42;0
WireConnection;58;0;24;0
WireConnection;39;0;63;0
WireConnection;39;1;50;0
WireConnection;39;2;56;0
WireConnection;38;0;59;0
WireConnection;38;1;54;0
WireConnection;41;0;39;0
WireConnection;0;2;38;0
WireConnection;0;9;41;0
ASEEND*/
//CHKSM=5977100682EF5776BBB886A085208574DCCEDEB7