extends GPUParticles3D

func _ready() -> void:
	emitting = true
	
	# Wait for the particles to finish, then delete the node
	await finished
	queue_free()
