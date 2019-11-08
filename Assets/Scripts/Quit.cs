using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Oculus;

public class Quit : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
        OVRInput.Update();
        Debug.Log(OVRInput.IsControllerConnected(OVRInput.Controller.RTouch));
        Debug.Log(OVRInput.IsControllerConnected(OVRInput.Controller.LTouch));

        if (OVRInput.GetDown(OVRInput.Button.One, OVRInput.Controller.LTouch) || Input.GetKey(KeyCode.Escape))
        {
            #if UNITY_EDITOR
                UnityEditor.EditorApplication.isPlaying = false;
            #else
                Application.Quit();
            #endif
        }
    }

    void FixedUpdate()
    {
        OVRInput.FixedUpdate();
    }
}
