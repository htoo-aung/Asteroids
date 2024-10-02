extends Node2D

@export var asteroid_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AsteroidTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var new_asteroid = asteroid_scene.instantiate()
	
	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	var direction = asteroid_spawn_location.rotation + PI / 2
	new_asteroid.position = asteroid_spawn_location.position
	
	#var force = 100.0
	#new_asteroid.apply_central_impulse(Vector2.DOWN.rotated(rotation) * force)
	
	direction += randf_range(-PI / 4, PI / 4)
	new_asteroid.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	new_asteroid.linear_velocity = velocity.rotated(direction)
	
	add_child(new_asteroid)
