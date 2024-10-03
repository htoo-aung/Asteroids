extends Node

@onready var health_bar: TextureProgressBar = $"../HealthBar"
@onready var player: RigidBody2D = $"../Player"
@onready var game_over_label: Label = $"../GameOverLabel"
@onready var retry_button: Button = $"../GameOverLabel/RetryButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_health(player.get_health())
	game_over()
	
func update_health(player_health: float):
	health_bar.value = player_health
	
func game_over():
	if (player.get_health() <= 0):
		game_over_label.visible = true
		retry_button.visible = true
		retry_button.disabled = false


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
