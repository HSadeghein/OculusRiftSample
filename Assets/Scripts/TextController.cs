using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class TextController : MonoBehaviour
{
    private Text mText;
    private string mZoneText, mExit, mMovePlayer, mLightSwitching;
    [HideInInspector]
    public bool mZoneEntered;
    private bool mZoneEnteredLast;
    // Start is called before the first frame update
    void Start()
    {
        GUIStyle style = new GUIStyle();
        style.richText = true;
        mText = GetComponent<Text>();
        mExit = $"*Press the Second Button of the Left Controller to Exit ==> <b><color=red>Y</color></b>\n";
        mMovePlayer = $"*Prees the First Button of Left Controller to Change your Position ==> <b><color=black>X</color></b>\n";
        mLightSwitching = $"*Press the First Button of Right Controller to Change the Light Color ==> <b><color=Orange>A</color></b>\n";
        mZoneText = $"*You have not Entered to the Zone\n";
        mZoneEntered = false;
        mZoneEnteredLast = false;
        mText.text = mExit + mMovePlayer + mLightSwitching + mZoneText;
    }

    // Update is called once per frame
    void Update()
    {
        if(mZoneEntered!= mZoneEnteredLast)
        {
            mZoneText = $"*You have Entered to the Zone\n";
            mText.text = mExit + mMovePlayer + mLightSwitching + mZoneText;
        }
    }
}
