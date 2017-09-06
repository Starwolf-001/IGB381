﻿using UnityEngine;
using System.Collections;

public class EthanShader : MonoBehaviour 
{

    // Use this for initialization
    void Start ()
	{
		Texture2D tex1 	= (Texture2D)Resources.Load("ethan_COLOR", typeof(Texture2D));
		Texture2D tex2  = (Texture2D)Resources.Load("ethan_NRM", typeof(Texture2D));
		tex1.filterMode = FilterMode.Trilinear;		// Options are Binlinear, Trilinear
		tex1.wrapMode 	= TextureWrapMode.Repeat;	// Change to Repeat and compare results
		tex1.anisoLevel = 9;						// Quality values between 1 and 9
		tex2.filterMode = FilterMode.Trilinear;		// Options are Binlinear, Trilinear
		tex2.wrapMode 	= TextureWrapMode.Repeat;	// Change to Repeat and compare results
		tex2.anisoLevel = 9;						// Quality values between 1 and 9

        if (tex1 != null && tex2 != null)
		{
			GetComponent<Renderer>().material.SetTexture("_Tex1", tex1);
            GetComponent<Renderer>().material.SetTexture("_Tex2", tex2);
		}
		else
		    Debug.Log("Failed to load image");
	}
	
	// Update is called once per frame
	void Update () 
	{

    }

}