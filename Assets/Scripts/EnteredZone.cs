using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnteredZone : MonoBehaviour
{
    public Text mText;
    public GameObject mSphere;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void OnTriggerEnter(Collider other)
    {
        GameObject.Find("/Canvas/Text").GetComponent<TextController>().mZoneEntered = true;
        mSphere.GetComponent<Rigidbody>().useGravity = true;
    }


}
