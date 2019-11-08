using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Oculus;
public class LightSwithcing : MonoBehaviour
{

    private Light mLight;
    // Start is called before the first frame update
    void Start()
    {
        mLight = GetComponent<Light>();
    }

    // Update is called once per frame
    void Update()
    {
         //OVRInput.Update();
        if (OVRInput.GetDown(OVRInput.Button.One,OVRInput.Controller.RTouch) || Input.GetKeyDown(KeyCode.Z))
        {
            mLight.color = new Color(1.0f, 0.0f, 0.0f);
        }
    }
    private void FixedUpdate()
    {
        //OVRInput.FixedUpdate();
    }
}
