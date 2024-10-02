extends Node

@onready var progress_bar: ProgressBar = $"../ProgressBar"
@onready var player: RigidBody2D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_health(player.get_health())
	
func update_health(player_health: float):
	progress_bar.value = player_health
