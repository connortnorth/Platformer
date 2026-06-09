extends Node2D

var current_level_root: Node = null
var level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup the level
	current_level_root = get_node("LevelRoot")
	_load_level(level)


func _load_level(level_number: int) -> void:
	if current_level_root:
		current_level_root.queue_free()
		
	var level_path = "res://Scenes/Levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
func _setup_level(level_root: Node) -> void:
	#Connect Level
	var Exit = level_root.get_node("Exit")
	Exit.body_entered.connect(_next_level)
	#connect enemies
	var enemies = level_root.get_node_or_null("enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.ded.connect(_on_ded)
	#connect Apples
	var Apples = level_root.get_node_or_null("Apples")
	if Apples:
		for apple in Apples.get_children():
			apple.apple_collected.connect(_apple_collected)


#signals:

func _on_ded(body):
	body.die()


func _next_level(body: Node2D) -> void:\
	if body.name == "Player":
		level += 1
		body.can_move = false
		_load_level(level)
		body.can_move = true

#Score:

@onready var score_label: Label = $"HUD/ScorePanel/Score Label"
var score = 0

func _apple_collected():
	score += 1
	score_label.text = "Score : %s" % score
