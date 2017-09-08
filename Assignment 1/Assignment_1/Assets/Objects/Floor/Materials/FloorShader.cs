/*
 * Name: FloorShader.cs
 * Date: 08/09/2017
 * Author: Michael Cartwright
 * Version: 2.0
 * Script that applies color and normal map textures to Floor with Trilinear and Anisotropic filters
 */

using UnityEngine;
using System.Collections;

public class FloorShader : MonoBehaviour 
{
    /*
     * Initialization
     * Pre: Loads color and normal map textures specified from Resources
     * Post: Applies Trilinear, Wrap and Anisotropic to textures and renders them
     */
    void Start ()
	{
		Texture2D tex1 	= (Texture2D)Resources.Load("tile_floor_COLOR", typeof(Texture2D)); // COLOR TEXTURE
		Texture2D tex2  = (Texture2D)Resources.Load("tile_floor_NRM", typeof(Texture2D)); // NORMAL MAP
        tex1.filterMode = FilterMode.Trilinear;     // Set to Trilinear
        tex1.wrapMode = TextureWrapMode.Repeat;
		tex1.anisoLevel = 9;						// Set to highest quality
		tex2.filterMode = FilterMode.Trilinear;     // Set to Trilinear
        tex2.wrapMode = TextureWrapMode.Repeat;
		tex2.anisoLevel = 9;						// Set to highest quality

        // Checks if textures loaded
        if (tex1 != null && tex2 != null)
		{
			GetComponent<Renderer>().material.SetTexture("_Tex1", tex1);
            GetComponent<Renderer>().material.SetTexture("_Tex2", tex2);
        }
		else
		    Debug.Log("Failed to load image");
	}
}
