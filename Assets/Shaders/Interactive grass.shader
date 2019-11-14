


Shader "HW1/Interactive grass" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_GroundColor ("Ground Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_Height("_Height", Range( 0 , 10)) = 4
		_FlatMargin("Flat MArgin", Float) = 200
		_Curveture("Curveture", Float) = 25
		_SwingSpeed("Swing Speed", Float) = 0
		_Noise("Noise", Float) = 0
		_SwingAmplitude("Swing Amplitude", Float) = 0
		_HeightStart("Height Start", Float) = 0
		_HeightFactor("Height Factor", Float) = 0
		[PerRendererData][HideInInspector] _FarhadWorldPos("",Vector) = (0,0,0,0)
		[HideInInspector] _GroundWorldPos("", Vector) = (0,0,0,0)

	}
	CGINCLUDE
		uniform float _SwingAmplitude;
		uniform float _SwingSpeed;
		uniform float _HeightFactor;
		uniform float _HeightStart;
		uniform float _Noise;
			inline float rand(float3 co)
			 {
			     return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) ) ) * 43758.5453  );
			 }
			inline float3 mod289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

			inline float2 mod289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

			inline float3 permute( float3 x ) { return mod289( ( ( x * 34.0 ) + 1.0 ) * x ); }

			inline float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}

			inline float4 vertexDataFunc( float4 vertex  )
			{
				float mulTime43 = _Time.y * 2.0;
				float3 ase_vertex3Pos = vertex.xyz;
				float temp_output_42_0 = ( ( mulTime43 + ase_vertex3Pos.x + ase_vertex3Pos.z ) * _SwingSpeed );
				float4 appendResult90 = (float4(sin( temp_output_42_0 ) , 0.0 , cos( temp_output_42_0 ) , 0.0));
				float temp_output_95_0 = ( _HeightFactor * ( _HeightStart - ase_vertex3Pos.y ) );
				float2 appendResult76 = (float2(ase_vertex3Pos.x , ase_vertex3Pos.y));
				float simplePerlin2D68 = snoise( ( appendResult76 + _Time.y ) );
				float2 appendResult77 = (float2(ase_vertex3Pos.z , ase_vertex3Pos.y));
				float simplePerlin2D75 = snoise( ( _Time.y + appendResult77 ) );
				float4 appendResult74 = (float4(simplePerlin2D68 , 0.0 , simplePerlin2D75 , 0.0));
				float4 VertexAnimation15 = ( ( rand(vertex.yyy) * _SwingAmplitude * appendResult90 * temp_output_95_0 ) + (rand(vertex.xzx) * _Noise * appendResult74 * temp_output_95_0 ) );
				return  VertexAnimation15;
			}
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
					 1,  9,  3, 11,
					13,  5, 15,  7,
					 4, 12,  2, 10,
					16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16;
			}
	ENDCG
	SubShader {
		Tags { "RenderType"="Opaque"
				 "DisableBatching" = "true"
		 }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert fullforwardshadows addshadow  vertex:vertex 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		#define SIZE 256


		struct Input {
			float2 uv_MainTex;
			float3 localPos;
		};
		sampler2D _MainTex;
		float4 _ObjectsWorldPosition[SIZE];
		half _Glossiness;
		half _Metallic;
		fixed4 _Color, _GroundColor;
		float4 _FarhadWorldPos;
		fixed3 _ReferenceDirection;
		half _Curveture;
		half _FlatMargin;
		half _HorizonWaveFrequency;
		sampler2D _NoiseTex;
		float _Height;
		fixed4 _GroundWorldPos;

		float4 Bend(float4 v){
			float4 worldPos = mul(unity_ObjectToWorld, v);
			float2 xzDist = (worldPos.xz - _FarhadWorldPos.xz);
			float dist = length(xzDist);
			float2 direction = lerp(_FarhadWorldPos.xz, xzDist, min(dist, 1));

			float theta = acos(clamp(dot(normalize(direction), _FarhadWorldPos.xyz), -1, 1));

			dist = max(0, dist - _FlatMargin);

			worldPos.y -= dist * dist * _Curveture * cos(theta);


			return mul(unity_WorldToObject, worldPos);
		}

		float4 Scale(float4 v, float4 objectWorldPos){
			objectWorldPos.y += 0.5;
			float scaleOffset = 1;
			float positionOffsetScale = 0;
			float3 positionOffset = float3(0,0,0);

			float4 worldPos = mul(unity_ObjectToWorld, v);
			float4 worldOrigin = mul(unity_ObjectToWorld, float4(0,0,0,1));

			// worldPos.x += 2;
			// worldOrigin.x += 2;
			float4 FG_vector = (worldPos - objectWorldPos);
			float FG_distance = length(FG_vector.xyz);
			float attenuation = 1 / (1 + dot(FG_vector.xyz, FG_vector.xyz) * 1	);
			// attenuation *= clamp(worldPos.z,1,2);
			if(FG_distance < 2){
				scaleOffset = FG_distance / 2;

			}

			float tmp = 0.1;
			// worldPos.xyz += max(FG_vector *  attenuation , mul(unity_ObjectToWorld, float3(tmp, tmp, tmp)))  - mul(unity_ObjectToWorld, float3(tmp, tmp, tmp));
			worldOrigin.xyz += (FG_vector.xyz * attenuation )  ;


			// worldPos += (max( FG_distance * -1, 0) / 10) ;
			// worldOrigin += (max(FG_distance * -1, 0) / 10) ;

			// worldPos.z += (min( FG_distance,2) / 10) * sign(FG_vector);
			// worldOrigin.z += (min(FG_distance,2) / 10) * sign(FG_vector);
			// worldPos.x += positionOffset.x;
			// worldOrigin.x += positionOffset.x;

			float3 distance = worldPos.xyz - worldOrigin;

			float3 translation =  (FG_vector.xyz *  max(attenuation - 0.1, 0.0)  )  ;

			worldPos.x = worldOrigin.x + translation.x + distance.x * scaleOffset ;
			worldPos.y = worldOrigin.y + translation.y + distance.y * scaleOffset ;
			worldPos.z = worldOrigin.z + translation.z + distance.z * scaleOffset ;

			return mul(unity_WorldToObject, worldPos); 
		}

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		// UNITY_INSTANCING_BUFFER_START(Props)
		// 	// put more per-instance properties here
		// UNITY_INSTANCING_BUFFER_END(Props)

		void vertex(inout  appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input, o);

			o.localPos = v.vertex;
			o.uv_MainTex = v.texcoord.xy;
			float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
			float4 Foliage = vertexDataFunc(worldPos );
			// v.vertex = mul(unity_WorldToObject, worldPos);
			v.vertex += Foliage;

			for(int i = 0; i < SIZE; i++){
				v.vertex = Scale(v.vertex, _ObjectsWorldPosition[i]);
			}

			// v.vertex +=  rand(v.vertex.xzy) * Foliage;
			// worldPos.y += 2;
		}

		void surf (Input IN, inout SurfaceOutput  o) {
			// float3 ase_worldPos = IN.worldPos;

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			// Metallic and smoothness come from slider variables
			// o.Specular  = _Metallic;
			// o.Gloss  = _Glossiness;
			o.Alpha = c.a;
			//float4 appendResult4 = (float4(( ase_worldPos.x * 0.1 ) , ( ase_worldPos.z * 0.1 ) , ase_worldPos.y - _GroundWorldPos.y, 0.0));
			//float temp_output_38_0 = saturate( ( tex2D( _NoiseTex, IN.uv_MainTex ).r * saturate( ( ( 1.0 / max( 0.01 , _Height ) ) * ( _Height - appendResult4.z ) ) ) ) );
			//float4 final = lerp(c, _GroundColor, temp_output_38_0);
			float4 final = lerp(_Color ,_GroundColor,1 - pow(IN.localPos.z,_Height));
			o.Albedo = final.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
