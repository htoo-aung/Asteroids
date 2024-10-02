extends Node

@onready var scoreLabel: Label = $"../Score"

var score = 0

func add_score():
	score += 1
	scoreLabel.text = "Score: " + str(score)
