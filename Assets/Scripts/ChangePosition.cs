﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.XR;
using UnityEngine.XR;

public class ChangePosition : MonoBehaviour
{

    private Vector3 mInitialPosition, mDstPosition;
    private bool mChangePos = false;
    public float mAutoMovementSpeed = 1;
    public GameObject mDstObject;
    public float mSpeed = 2.0f;
    // Start is called before the first frame update
    void Start()
    {
        mInitialPosition = transform.position;
        mDstPosition = mDstObject.transform.position;
        QualitySettings.vSyncCount = 0;
        //Application.targetFrameRate = 144;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.X) || OVRInput.GetDown(OVRInput.Button.One, OVRInput.Controller.LTouch))
        {
            mChangePos = true;
        }
        if (mChangePos)
        {
            Debug.Log("Befor" + transform.position);

            transform.position =  Vector3.Lerp(transform.position, mDstPosition, Time.deltaTime * mAutoMovementSpeed) ;
            Debug.Log("After" + transform.position);
            Vector3 s = mDstPosition - transform.position;
            if (s.magnitude <= 0.3f)
            {
                Debug.Log("destination found");
                Vector3 tmp = mDstPosition;
                mDstPosition = mInitialPosition;
                mInitialPosition = tmp;
                mChangePos = false;
            }
        }

        Vector3 movement = InputTracking.GetLocalRotation(XRNode.HardwareTracker) * new Vector3(OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick).x, 0, OVRInput.Get(OVRInput.Axis2D.PrimaryThumbstick).y) * Time.deltaTime * mSpeed;
        movement.y = 0;
        transform.position += movement;


    }

}
