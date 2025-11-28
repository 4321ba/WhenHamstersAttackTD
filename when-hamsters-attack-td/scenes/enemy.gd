extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var speed = 3.0
@export var max_health = 10.0
@export var damage_when_achieved_goal = 1
var health = 0


# --- Animation Configuration ---
@export_group("Visuals & Animation")
@export var bob_speed: float = 12.0

# Assign these in the Inspector for each scene!
@export var heads_to_bob: Array[Node3D] # For Tanks/VTBs (Drag the head/turret here)
@export var body_to_bob: Node3D         # For Infantry (Drag the main mesh here)
@export var legs: Node3D                # [NEW] For Infantry: The single object containing both legs

var anim_time: float = 0.0

func distance_to_goal():
	return nav_agent.distance_to_target()

func _ready() -> void:
	health = max_health
	nav_agent.target_position = $"/root/MainScene/Goal".global_position


func _process(delta: float) -> void:
	# Only animate if moving
	if velocity.length() > 0.1:
		anim_time += delta * bob_speed
		_animate_parts()
	else:
		_reset_pose(delta)


func _physics_process(_delta: float) -> void:
	# If the agent is hopelessly lost (or fallen), snap them back to the mesh
	#if not nav_agent.is_target_reachable():
	#	var valid_point = NavigationServer3D.map_get_closest_point(get_world_3d().navigation_map, global_position)
	#	global_position = valid_point
	
	var new_velocity = (nav_agent.get_next_path_position() - global_position).normalized() * speed
	
	#nav_agent.velocity = new_velocity
	velocity = new_velocity
	if velocity:
		look_at(global_position + velocity)
	move_and_slide()

func _on_navigation_agent_3d_target_reached() -> void:
	print("I've got in!")
	HealthAndMoney.i.remove_health(damage_when_achieved_goal)
	queue_free()


@onready var health_bar_red: Sprite3D = $HealthBar/Red

func take_damage(amount: float):
	health -= amount
	
	# Clamp health to 0
	health = max(health, 0.0)
	
	# Calculate percentage (0.0 to 1.0)
	var health_percent = health / max_health
	
	# Update the scale
	# We tween it for a polished "smooth" drop effect
	var tween = create_tween()
	tween.tween_property(health_bar_red, "scale:x", health_percent, 0.2)
	
	if health <= 0:
		die()

func die():
	HealthAndMoney.i.add_money(damage_when_achieved_goal)
	queue_free()



func _animate_parts():
	var sine_wave = sin(anim_time)
	var cosine_wave = cos(anim_time)
	
	# 1. Tank/VTB Head Bobbing
	if heads_to_bob.size() >= 1:
		heads_to_bob[0].position.y = abs(sin(anim_time/2)) * 0.05
		heads_to_bob[0].position.x = cos(anim_time/2) * 0.1
	if heads_to_bob.size() >= 2:
		heads_to_bob[1].position.y = abs(cos(anim_time/2)) * 0.05
		heads_to_bob[1].position.x = sin(anim_time/2) * 0.1
		
	# 2. Infantry Body Bobbing
	if body_to_bob:
		# Bounce logic
		var bounce = abs(sine_wave) 
		body_to_bob.position.y = bounce * 0.1
		body_to_bob.rotation.x = cosine_wave * 0.1

	# 3. [NEW] Infantry Leg Mirroring
	if legs:
		# We flip the legs every time the sine wave completes a half-cycle
		# Using sign() gives us 1.0 or -1.0 immediately
		legs.scale.z = -sign(sine_wave)

func _reset_pose(delta):
	var lerp_speed = delta * 5.0
	
	if body_to_bob:
		body_to_bob.position = body_to_bob.position.lerp(Vector3(0,0,0), lerp_speed)
		body_to_bob.rotation.x = lerp_angle(body_to_bob.rotation.x, 0.0, lerp_speed)
	
	if legs:
		# Reset scale to normal
		legs.scale.z = 1.0
