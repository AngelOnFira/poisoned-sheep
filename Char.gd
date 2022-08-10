extends KinematicBody


var mouse_sensitivity = 0.03
var speed = 14;
var gravity = 75; # how quickly you accelerate when in air (gravity) 
var jump_impulse = 20;

var velocity = Vector3.ZERO;
onready var head = $head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	var direction = Vector3.ZERO;
	
	# Remember, the ground plane is the X and Z! The Y axis is up and down. (thank you minecraft)
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x;
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x;
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z;
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z;
	
	# Normalize vector for when two are pressed at once... vectors op
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$MeshInstance.look_at(translation + direction, Vector3.UP) # move character, keep looking at character. 
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse;
		
	velocity.x = direction.x * speed;
	velocity.z = direction.z * speed;
	
	velocity.y -= gravity * delta;
	
	velocity = move_and_slide(velocity, Vector3.UP); # set velocity equal to what move and slide returns to avoid bugs and massive headaches
	
	
