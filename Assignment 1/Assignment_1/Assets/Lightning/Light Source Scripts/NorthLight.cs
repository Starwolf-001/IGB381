using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NorthLight : MonoBehaviour {

    public int speed;
    public float angle;
    public Text textSpeed;

    // Use this for initialization
    void Start()
    {
        // Default Speed
        speed = 0;
        // Default angle
        angle = 25f;
    }

    // Update is called once per frame
    void Update()
    {
        if(speed != 0)
        {
            Pivot();
        }
        CurrentSpeedUI();
    }

    void Pivot()
    {
        transform.rotation = Quaternion.Euler(0f, 90f + angle * Mathf.Sin(Time.time * speed), 0f);
    }

    void CurrentSpeedUI()
    {
        //textSpeed.text = speed.ToString();
    }
}
