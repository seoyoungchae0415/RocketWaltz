extends CharacterBody2D

signal rocket_fired(rocket, position, rotation)

@onready var game: Node2D = $"."
@onready var rocket = load("res://scenes/rocket.tscn")

var testint = 5

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("attack"):
		var rocket_inst = rocket.instantiate()
		
		rocket_inst.direction = global_rotation
		rocket_inst.spawnPos = global_position
		rocket_inst.spawnRot = global_rotation
		# game.add_child.call_deferred(rocket_inst)
		get_parent().get_parent().add_child(rocket_inst)
		emit_signal("rocket_fired", rocket_inst, global_position, global_rotation)
