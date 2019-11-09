using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetWorldPos : MonoBehaviour {
    private int farhadworldposID;
    private Renderer _renderer;
    private MaterialPropertyBlock _propBlock;
    public GameObject[] objects;
    private List<Vector4> _posList;
    Ray ray;
    Material material;
    RaycastHit hitInfo;
    // Use this for initialization
    void Awake()
    {
        _posList = new List<Vector4>();
        _propBlock = new MaterialPropertyBlock();
        _renderer = GetComponent<Renderer>();
        farhadworldposID = Shader.PropertyToID("_ObjectsWorldPosition");


    }
    private void Start()
    {
            //_renderer.GetPropertyBlock(_propBlock);

      /*  ray = new Ray(this.gameObject.transform.position + new Vector3(0, 1, 0), Vector3.down);

        if (Physics.Raycast(ray, out hitInfo, 10))
        {
            //Renderer rend = hitInfo.transform.GetComponent<Renderer>();
            //Texture2D tex = rend.material.mainTexture as Texture2D;
            //Vector2 pixelUV = hitInfo.textureCoord;
            //pixelUV.x *= tex.width;
            //pixelUV.y *= tex.height;
            //Color groundcolor = tex.GetPixel((int)pixelUV.x, (int)pixelUV.y);
            //this.GetComponent<Renderer>().sharedMaterial.SetColor("_GroundColor", groundcolor);
            this.GetComponent<Renderer>().sharedMaterial.SetColor("_GroundColor", hitInfo.collider.GetComponent<Renderer>().material.GetColor("_Color"));
            this.GetComponent<Renderer>().sharedMaterial.SetVector("_GroundWorldPos", hitInfo.point);
            
        }
            //_renderer.SetPropertyBlock(_propBlock);
            */
    }

    // Update is called once per frame
    void Update() {
        _posList.Clear();
        for (int i = 0; i < objects.Length; i++)
        {
            _posList.Add(objects[i].transform.position);
        }
        // Get the current value of the material properties in the renderer.
            //_renderer.GetPropertyBlock(_propBlock);
        // Assign our new value.
        this.GetComponent<Renderer>().sharedMaterial.SetVectorArray(farhadworldposID, _posList);

        // Apply the edited values to the renderer.
            //_renderer.SetPropertyBlock(_propBlock);


    }

}

