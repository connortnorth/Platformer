extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_level() -> void:
	#connect enemies
	var enemies = $LevelRoot.get_node_or_null("enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.ded.connect(_on_ded)


#signals:

func _on_ded(body):
	body.die()
