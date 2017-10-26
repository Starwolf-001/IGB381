/*
 * Name: SunOrbit.cs
 * Date: 08/09/2017
 * Author: Michael Cartwright
 * Version: 1.2
 * Allows for Scene Sun directional light to orbit around the scene based of user defined speed and system time
 */

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class SunOrbit : MonoBehaviour {

    // User defined variables
    // Variables that can be changed
    public int speed;
    // Time variables in seconds
    public float time;
    public TimeSpan currentTime;
    // Sun directional light variables
    public Transform sunTrans;
    public Light sun;
    // Sun light source intensity
    public float intensity;
    // variables for UI
    public Text textTime;

    /*
     * Initialization
     * Pre: speed and time set for Sun
     * Post: Update() called to update per frame
     */
    void Start()
    {
        // Default speed
        speed = 1;
        // Default time set to 0600 hours
        time = 21600;
    }

    /*
     * Update per frame
     * Pre: Calls ChangeTime();
     * Post: Continues to update per frame
     */
    void Update ()
    {
        ChangeTime();
    }

    /*
     * Orbits the Sun based on the time of the day and changes the intensity of the sun during the night cycle
     * Pre: Calculates the time of the day and converts hours and minutes to String for UI.
     * Post: Rotates the sun and changes the intensity of the Sun directional light source. 
     */
    public void ChangeTime()
    {
        // Calculates the time of day
        time += Time.deltaTime * speed;
        // Resets the time if a 24 hour cycle completes
        if(time > 86400)
        {
            time = 0;
        }
        // Takes the time and converts to String for Canvas/Sun Time Label
        currentTime = TimeSpan.FromSeconds(time);
        // Split into parts
        string[] tempTime = currentTime.ToString().Split(":"[0]);
        textTime.text = tempTime[0] + ":" + tempTime[1];

        // Rotate the sun over time in a 360 degree circular orbit
        sunTrans.rotation = Quaternion.Euler(new Vector3((time - 21600) / 86400 * 360, 0, 0));

        // Calculate value of intensity based of the time of day or night
        if(time < 43200)
        {
            // During the day 
            intensity = 1 - (43200 - time) / 43200;
        }
        else
        {
            // During the night
            intensity = 1 - ((43200 - time) / 43200 * -1);
        }
        // Change the Sun directional light's intensity over time
        sun.intensity = intensity;
    }
}
