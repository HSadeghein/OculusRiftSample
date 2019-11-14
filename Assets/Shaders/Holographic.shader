Shader "HW1/Holographic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]_MainColor("Main Color", Color) = (1,1,1,1)
        // Rim/Fresnel
		[HDR]_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimPower ("Rim Power", Range(1, 10)) = 5.0
        _Direction ("Direction", Vector) = (0,1,0,0)

        _GlowTiling("Glow Tiling", float) = 1.0
        _GlowSpeed("Glow Speed", float) = 1.0

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue"="Transparent" "DisableBathing" = "True"}
        LOD 100
        Blend Srcalpha OneMinusSrcAlpha
        Cull Back
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
                
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _RimColor,_Direction, _MainColor;
            float _RimPower,_GlowSpeed,_GlowTiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(UnityWorldSpaceViewDir(o.worldPos.xyz));
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
			{
				fixed4 texColor = tex2D(_MainTex, i.uv);
				half dirVertex = (dot(i.worldPos, normalize(float4(_Direction.xyz, 1.0))) + 1) / 2;

				// Rim Light
				half rim = 1.0-saturate(dot(i.viewDir, i.worldNormal));
				fixed4 rimColor = _RimColor * pow (rim,  sin(_Time.g) + _RimPower * 1.0f );

                float glow = frac(dirVertex * _GlowTiling * pow(1 - i.uv.y,2) - _Time.x * _GlowSpeed);


				fixed4 col = rimColor + (glow) * _MainColor * _MainColor.a;


				return col;
			}
            ENDCG
        }
    }
}
