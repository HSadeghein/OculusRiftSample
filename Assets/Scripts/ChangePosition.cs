using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangePosition : MonoBehaviour
{

    private Vector3 mInitialPosition, mDstPosition;
    private bool mChangePos = false;
    public float mSpeed = 1;
    public GameObject mDstObject;
    // Start is called before the first frame update
    void Start()
    {
        mInitialPosition = GetComponent<Transform>().transform.position;
        mDstPosition = mDstObject.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.S))
        {
            mChangePos = true;
        }
        if (mChangePos)
        {
            transform.position = Vector3.Lerp(transform.position, mDstPosition, Time.deltaTime * mSpeed);
            Debug.Log("MAG==>" + Mathf.Abs(mDstPosition.magnitude - transform.position.magnitude));
            Debug.Log("dst ==>" + mDstPosition);
            if (Mathf.Abs(mDstPosition.magnitude - transform.position.magnitude) < 0.3f)
            {
                Debug.Log("destination found");
                Vector3 tmp = mDstPosition;
                mDstPosition = mInitialPosition;
                mInitialPosition = tmp;
                mChangePos = false;
            }
        }
    }
}
