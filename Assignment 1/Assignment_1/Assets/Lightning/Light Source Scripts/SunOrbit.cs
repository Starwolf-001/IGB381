using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class SunOrbit : MonoBehaviour {

    public int speed;
    public float time;
    public TimeSpan currentTime;
    public Transform sunTrans;
    public Light sun;
    public Text textTime;
    public int days;
    public float intensity;

    void Start()
    {
        speed = 1;
        time = 21600;
    }

    // Update is called once per frame
    void Update ()
    {
        ChangeTime();
    }

    public void ChangeTime()
    {
        time += Time.deltaTime * speed;
        if(time > 86400)
        {
            days += 1;
            time = 0;
        }
        currentTime = TimeSpan.FromSeconds(time);
        string[] tempTime = currentTime.ToString().Split(":"[0]);
        textTime.text = tempTime[0] + ":" + tempTime[1];

        sunTrans.rotation = Quaternion.Euler(new Vector3((time - 21600) / 86400 * 360, 0, 0));

        if(time < 43200)
        {
            intensity = 1 - (43200 - time) / 43200;
        }
        else
        {
            intensity = 1 - ((43200 - time) / 43200 * -1);
        }

        sun.intensity = intensity;
    }
}
