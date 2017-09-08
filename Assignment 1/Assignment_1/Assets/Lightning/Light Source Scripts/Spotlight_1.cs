using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Spotlight_1 : MonoBehaviour {

    public int speed;
    public float angle;
    public Text textSpeed;
    public Text textAngle;

    // Use this for initialization
    void Start()
    {
        // Default Speed
        speed = 1;
        // Default angle
        angle = 10f;
    }

    // Update is called once per frame
    void Update()
    {
        if (speed != 0)
        {
            Pivot();
        }
        CurrentSpeedUI();
    }

    void Pivot()
    {
        transform.rotation = Quaternion.Euler(90 + angle * Mathf.Sin(Time.time * speed), 180 + angle * Mathf.Sin(Time.time * speed), angle * Mathf.Sin(Time.time * speed));
    }

    void CurrentSpeedUI()
    {
        textSpeed.text = speed.ToString();
        textAngle.text = angle.ToString();
    }
}
