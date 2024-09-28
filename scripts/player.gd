extends CharacterBody2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

var rotate_speed := 5.0

func _physics_process(delta: float) -> void:
	get_input(delta)
	
func get_input(delta: float):
	if(Input.is_anything_pressed() == false):
		animatedSprite.play("idle")
	
	if(Input.is_action_pressed("rotate_left")):
		self.rotation += rotate_speed * delta
		animatedSprite.play("rotate_left")
		
	if(Input.is_action_pressed("rotate_right")):
		self.rotation -= rotate_speed * delta
		animatedSprite.play("rotate_right")
