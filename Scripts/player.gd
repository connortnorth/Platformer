extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

const SPEED = 300.0
const JUMP_VELOCITY = -850
var alive = true
var startPositionX = position.x
var startPositionY = position.y

func _ready() -> void:
	startPositionX = position.x
	startPositionY = position.y

func _process(_delta: float) -> void:
	if !alive and animated_sprite_2d.frame == 6:
		position.x = startPositionX
		position.y = startPositionY
		animated_sprite_2d.animation = "idle"
		alive = true


func _physics_process(delta: float) -> void:
	if !alive:
		return

	if velocity.x < -1 or velocity.x > 1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"

	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	if direction == -1.0: 
		animated_sprite_2d.flip_h = true

func die() -> void:
	alive = false
	animated_sprite_2d.animation = "dying"
	death_sound.play()
