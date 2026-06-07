extends Area2D
@onready var tile_map_layer: TileMapLayer = $"../../TileMapLayer"
@onready var snail_animate: AnimatedSprite2D = $"Snail Animate"

signal ded
const SPEED = 100
var direction = -1
var overlapping = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if overlaps_body(tile_map_layer):
		if overlapping == 0:
			direction *= -1
			overlapping = 1
	else:
		overlapping = 0
	position.x += direction * SPEED * delta
	
	if direction == -1:
		snail_animate.flip_h = false
	else:
		snail_animate.flip_h = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.alive:
		emit_signal("ded", body)
		print("ded")
