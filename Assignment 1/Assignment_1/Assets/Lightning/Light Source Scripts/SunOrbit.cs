using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SunOrbit : MonoBehaviour {

    public int speed;
    public Text textSpeed;
    public bool decreaseButton = false;
    public bool increaseButton = false;

    // Use this for initialization
    void Start ()
    {
        // Default Speed
        speed = 10;
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (decreaseButton == true)
        {
            speed--;
            decreaseButton = false;
        }
        if (increaseButton == true)
        {
            speed++;
            increaseButton = false;
        }
        if (speed != 0)
        {
            Orbit();
        }
        CurrentSpeedUI();
    }

    void Orbit()
    {
        transform.RotateAround(Vector3.zero, Vector3.right, speed * Time.deltaTime);
        transform.LookAt(Vector3.zero);
    }

    void CurrentSpeedUI()
    {
        textSpeed.text = speed.ToString();
    }
}
