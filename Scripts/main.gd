extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _setup_level() -> void:
	#connect enemies
	var enemies = $LevelRoot.get_node_or_null("enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.ded.connect(_on_ded)
	#connect Apples
	var Apples = $LevelRoot.get_node_or_null("Apples")
	if Apples:
		for apple in Apples.get_children():
			apple.apple_collected.connect(_apple_collected)


#signals:

func _on_ded(body):
	body.die()

#Score:

@onready var score: RichTextLabel = $score
var num = 0

func _apple_collected():
	var tempScore = (score.text).to_int() + 1
	tempScore = str(tempScore)
	score.text = "Score: " + tempScore
	print("Apple Collected")
	print(score.text)
	
