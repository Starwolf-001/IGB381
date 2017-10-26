using UnityEngine;
using System.Collections;

public class ThirdPersonCamera : MonoBehaviour {

    public Transform CameraTarget;
	private float x = 0.0f;
	private float y = 0.0f;
	
	public int cameraSpeed = 5;

	public bool invert = false;

	public float upAngleView = 45.0f;
	public float downAngleView = 65.0f;
	
	public float MaxViewDistance = 15f;
	public float MinViewDistance = 1f;
	public int ZoomRate = 20;
	private int lerpRate = 5;
	private float distance = 3f;
	private float desireDistance;
	private float correctedDistance;
	private float currentDistance;
	
	public float cameraTargetHeight = 1.0f;
	
	//checks if first person mode is on
	private bool click = false;
	
	// Use this for initialization
	void Start () {

		//Startup variable allocations
		//Vector3 Angles = transform.eulerAngles;
		//x = Angles.x;
		//y = Angles.y;
		currentDistance = distance;
		desireDistance = distance;
		correctedDistance = distance;
	}
	
	// Update is called once per frame
	void LateUpdate () {

		//Camera X movement
		x += Input.GetAxis("Mouse X") * cameraSpeed;
		
		//Mouse Invert Settings
		if (invert == false)
			y -= Input.GetAxis("Mouse Y") * cameraSpeed;
		else if (invert == true)
			y += Input.GetAxis("Mouse Y") * cameraSpeed;

		//Camera Y movement - Clamp Camera viewing angle to maxAngleView
		y = ClampAngle (y, -upAngleView, downAngleView);

		//Camera Rotation
		Quaternion rotation = Quaternion.Euler (y,x,0);

		//Camera Zoom
		desireDistance -= Input.GetAxis("Mouse ScrollWheel") * Time.deltaTime * ZoomRate * Mathf.Abs(desireDistance);
		desireDistance = Mathf.Clamp (desireDistance, MinViewDistance, MaxViewDistance);
		correctedDistance = desireDistance;

		//Camera Positioning
		Vector3 position = CameraTarget.position - (rotation * Vector3.forward * desireDistance);
		
		RaycastHit collisionHit;
		Vector3 cameraTargetPosition = new Vector3 (CameraTarget.position.x, CameraTarget.position.y + cameraTargetHeight, CameraTarget.position.z);
		
		bool isCorrected = false;

		if (Physics.Linecast (cameraTargetPosition, position, out collisionHit)) {
			position = collisionHit.point;
			correctedDistance = Vector3.Distance(cameraTargetPosition,position);
			isCorrected = true;
		}
		
		currentDistance = !isCorrected || correctedDistance > currentDistance ? Mathf.Lerp(currentDistance,correctedDistance,Time.deltaTime * ZoomRate) : correctedDistance;
		
		position = CameraTarget.position - (rotation * Vector3.forward * currentDistance + new Vector3 (0, -cameraTargetHeight, 0));
		
		transform.rotation = rotation;
		transform.position = position;

	}

	//Clamp method - limit Y rotation so the camera doesn't rotate over/under the player target
	private static float ClampAngle(float angle, float min, float max){
		if (angle < -360) {
			angle += 360;      
		}
		if (angle > 360) {
			angle -= 360;      
		}
		return Mathf.Clamp (angle,min,max);
	}
}