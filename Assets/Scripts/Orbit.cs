using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orbit : MonoBehaviour
{
    public float mOrbitSpeedArounditself, mOrbitSpeedAroundPrivot = 10.0f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Rotate object arount itself
        this.transform.Rotate(0, Time.deltaTime * mOrbitSpeedArounditself, 0, Space.World);
        //Rotate object arount a pivot
        this.transform.position =  Quaternion.Euler(new Vector3(0, Time.deltaTime * mOrbitSpeedAroundPrivot, 0)) * (transform.position - transform.parent.position) + transform.parent.position;
    }


}
