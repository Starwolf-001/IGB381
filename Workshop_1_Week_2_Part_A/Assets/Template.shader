Shader "Test/Template" {
	Properties {

		// Default variables for Unity C#
		
		myTexture ("My texture", 2D) = "White" {}
        myNormalMap ("My normal map", 2D) = "bump" {}
        myInt ("My integer", Int) = 2
        myFloat ("My float", Float) = 1.5
        myRange ("My range", Range(0.0, 1.0)) = 0.5
        myColor ("My colour", Color) = (1, 0, 0, 1)
        myVector ("My Vector4", Vector) = (0, 0, 0, 0)
	}

	SubShader {

		Pass {

			// Shader in CG to change colour of object

			CGPROGRAM

            sampler2D myTexture;
            sampler2D myNormalMap;
            int myInt;
            float myFloat;
            float myRange;
            half4 myColor;
            float4 myVector;

			#pragma vertex vert             
            #pragma fragment frag

            struct vertInput {
            	float4 pos : POSITION;
            };

            struct vertOutput {
            	float4 pos : SV_POSITION;
			};

			vertOutput vert(vertInput input) {
     		vertOutput o;
      		o.pos = mul(UNITY_MATRIX_MVP, input.pos);
           		return o;
    		}
 
    	 	half4 frag(vertOutput output) : COLOR {
           		return myColor; 
     		}

            ENDCG
		}

	}
}