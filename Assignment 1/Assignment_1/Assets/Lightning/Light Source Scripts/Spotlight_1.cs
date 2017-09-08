/*
 * Name: Spotlight_1.cs
 * Date: 08/09/2017
 * Author: Michael Cartwright
 * Version: 1.1
 * Allows for Scene Lamp_1/Spotlight_1 to pivot based on a user set speed and angle.
 */

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Spotlight_1 : MonoBehaviour {

    // User defined variables
    // Variables that can be changed
    public int speed;
    public float angle;
    // Variables for UI
    public Text textSpeed;
    public Text textAngle;

    /*
     * Initialization
     * Pre: speed and angle set for Lamp_1/Spotlight_1
     * Post: Update() called to update per frame
     */
    void Start()
    {
        // Default Speed
        speed = 1;
        // Default angle
        angle = 10f;
    }

    /*
     * Update per frame
     * Pre: If speed is not 0, calls Pivot() and UpdateUI()
     * Post: Continues to update per frame
     */
    void Update()
    {
        // if speed = 0, Lamp_1/Spotlight_1 will stop pivoting
        if (speed != 0)
        {
            Pivot();
        }
        UpdateUI();
    }

    /*
     * Rotates the Lamp_1/Spotlight_1 based on a user defined angle, speed and the system's time
     * Pre: Transforn rotates the Lamp_1/Spotlight_1
     * Post: Update() continues to update per frame
     */
    void Pivot()
    {
        transform.rotation = Quaternion.Euler(90 + angle * Mathf.Sin(Time.time * speed), 
                                              180 + angle * Mathf.Sin(Time.time * speed), 
                                              angle * Mathf.Sin(Time.time * speed));
    }

    /*
     * Converts speed and angle to a string for Unity Text UI
     * Pre: Converts speed and angle to Strings
     * Post: textSpeed and textAngle value update on Canvas/Spotlight 1 Speed Label and Canvas/Spotlight 1 Angle Label
     *       respectively
     */
    void UpdateUI()
    {
        textSpeed.text = speed.ToString();
        textAngle.text = angle.ToString();
    }
}
