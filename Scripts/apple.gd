extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collection_sound: AudioStreamPlayer2D = $"Collection Sound"

signal apple_collected
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if collected and animated_sprite_2d.frame == 5:
		animated_sprite_2d.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("apple_collected")
		animated_sprite_2d.animation = "collected"
		collected = true
		collection_sound.play()
