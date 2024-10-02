extends Node2D

@export var asteroid_scene: PackedScene

const PLAYER = preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AsteroidTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var new_asteroid = asteroid_scene.instantiate()
	#new_asteroid.start_lifetime()
	
	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	var direction = asteroid_spawn_location.rotation + PI / 2
	new_asteroid.position = asteroid_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	new_asteroid.rotation = direction
	
	var velocity = Vector2(randf_range(50.0, 300.0), 0.0)
	new_asteroid.linear_velocity = velocity.rotated(direction)
	
	add_child(new_asteroid)
