extends KinematicBody

#var h_rot = 0 #this is yaw

var direction = Vector3()
var velocity = Vector3()

var vertical_velocity = 0
var gravity = 20

var movement_speed = 10
var walk_speed = 10
var run_speed = 20
var acceleration = 6
var jump_strength = 10

var angular_acceleration = 7

var can_attack: bool = true

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	direction = Vector3()
	movement_speed = walk_speed
	
	if Input.is_action_pressed("move_backward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_forward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_right"):
		direction -= transform.basis.x
	
	elif Input.is_action_pressed("move_left"):
		direction += transform.basis.x
	
	if Input.is_action_pressed("run"):
		movement_speed = run_speed
	
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	direction = direction.rotated(Vector3.UP, h_rot).normalized()
	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)
	
	move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP, false, 4, PI/4, false)
	
	#move_and_slide(linear_velocity: Vector3, up_direction: Vector3 = Vector3( 0, 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true)
	
	if !is_on_floor():
		vertical_velocity += gravity * delta
	elif is_on_floor() && Input.is_action_pressed("jump"):
		vertical_velocity -= jump_strength
	else:
		vertical_velocity = 0
	
	$RotationHelper.rotation.y = lerp_angle($RotationHelper.rotation.y, $Camroot/h.rotation.y, delta * angular_acceleration)


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		if can_attack == true:
			swing_shovel()
		else:
			print("cooldown not finished!")


func swing_shovel():
	can_attack = false
	var overlapping_bodies = $RotationHelper/AttackArea.get_overlapping_bodies()
#	print("overlaping bodies: ", overlapping_bodies)
	
	var my_position = self.get_translation()
#	print("my pos: ", my_position)
	
	for body in overlapping_bodies:
		if(body != self && body is RigidBody):
			var body_position = body.get_translation()
#			print("body pos: ", body_position)
			
			var attack_vector = (body_position - my_position)
			attack_vector = attack_vector.normalized()
#			print("attack vector: ", attack_vector)
			
			body.apply_impulse(Vector3(0,0,0), attack_vector * 50)
			
		elif(body != self && body is KinematicBody):
			attack(body)
	
	$AttackCooldown.start()


func attack(body):
	print("attacked: ", body)


func _on_AttackCooldown_timeout():
	can_attack = true
	print("can attack agian")
