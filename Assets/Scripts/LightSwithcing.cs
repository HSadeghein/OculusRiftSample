using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Oculus;
public class LightSwithcing : MonoBehaviour
{

    private Light mLight;
    private Color mStartColor;
    // Start is called before the first frame update
    void Start()
    {
        mLight = GetComponent<Light>();
        mStartColor = mLight.color;
    }

    // Update is called once per frame
    void Update()
    {
        if (OVRInput.GetDown(OVRInput.Button.One,OVRInput.Controller.RTouch) || Input.GetKeyDown(KeyCode.Z))
        {
            if (mLight.color == mStartColor)
                mLight.color = Color.red;
            else
                mLight.color = mStartColor;
        }
    }

}
