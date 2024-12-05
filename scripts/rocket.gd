extends CharacterBody2D

@export var SPEED = 500
@onready var sprite_2d: Sprite2D = $Sprite2D

var direction : float
var spawnPos : Vector2
var spawnRot : float
# var aim = get_local_mouse_position()

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	spawnRot += 1.5708

func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(spawnRot)
	move_and_slide()
