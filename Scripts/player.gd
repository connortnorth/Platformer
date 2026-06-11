extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

const SPEED = 90
const JUMP_VELOCITY = -850
var alive = true
var can_move = true
var startPositionX = position.x
var startPositionY = position.y
var currentState = "idle"


func _ready() -> void:
	startPositionX = position.x
	startPositionY = position.y


func _on_animated_sprite_2d_animation_looped() -> void:
	if animated_sprite_2d.animation == "dying":
		position.x = startPositionX
		position.y = startPositionY
		animated_sprite_2d.animation = "idle"
		alive = true


func _physics_process(delta: float) -> void:
	if !alive:
		return

	if !can_move:
		animated_sprite_2d.animation = "idle"
		return

	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			currentState =  "jumping"
		elif velocity.x < -1 or velocity.x > 1:
			currentState = "running"
		else:
			currentState = "idle"
	else: 
		if is_on_wall():
			if not currentState == "wall jumping":
				currentState = "on wall"
			if Input.is_action_just_pressed("Jump"):
				var wall_normal = get_wall_normal()
				velocity.y = JUMP_VELOCITY
				velocity.x = wall_normal.x * SPEED * 35
				jump_sound.play()
				currentState = "wall jumping"
			else:
				if velocity.y < 0:
					velocity.y += get_gravity().y * delta
				else: 
					velocity.y += get_gravity().y * delta * 0.2
		else:
			if currentState == "wall jumping":
				currentState = "jumping"
			velocity.y += get_gravity().y * delta
			if not currentState.contains("jumping"):
				currentState = "falling"
	
	if currentState == "wall jumping":
		animated_sprite_2d.animation = "jumping"
	else:
		animated_sprite_2d.animation = currentState
	
	var direction := Input.get_axis("Left", "Right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	if direction < 0: 
		animated_sprite_2d.flip_h = true
	
	velocity.x *= 0.5
	velocity.x += direction * SPEED * 100 * delta
	
	move_and_slide()


func die() -> void:
	alive = false
	animated_sprite_2d.animation = "dying"
	death_sound.play()
