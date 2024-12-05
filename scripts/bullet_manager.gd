extends Node2D


func _on_weapon_2_rocket_fired(rocket_inst: Variant, pos: Vector2, rot: Variant) -> void:
	# print("CONNECTION SECURE")
	handle_rocket_fired(rocket_inst, pos, rot)

func handle_rocket_fired(rocket_inst, pos, rot):
	# print("ROCKET FIRED")
	add_child(rocket_inst)
	rocket_inst.spawnPos = pos
	print(rocket_inst.spawnPos)
	rocket_inst.spawnRot = rot
