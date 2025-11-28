extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var speed = 3.0
@export var max_health = 10.0
@export var damage_when_achieved_goal = 1
var health = 0

func distance_to_goal():
	return nav_agent.distance_to_target()

func _ready() -> void:
	health = max_health
	nav_agent.target_position = $"/root/MainScene/Goal".global_position

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
"""
func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	#velocity = velocity.move_toward(safe_velocity, 0.25)
	if (velocity - safe_velocity).length() > 1:
		print(velocity, safe_velocity)
	if velocity.length() > speed:
		safe_velocity = safe_velocity.normalized() * speed
	velocity = safe_velocity
	look_at(global_position + velocity)
	move_and_slide()
"""
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
