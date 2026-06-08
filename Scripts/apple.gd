extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collection_sound: AudioStreamPlayer2D = $"Collection Sound"

signal apple_collected

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("apple_collected")
		animated_sprite_2d.animation = "collected"
		collection_sound.play()

func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == "collected":
		queue_free()
