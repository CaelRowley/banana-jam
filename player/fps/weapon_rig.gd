class_name WeaponRig
extends Node3D

@export var default_weapon: Weapon
@export var current_weapon: Node3D


func _ready() -> void:
	load_weapon(default_weapon)


func load_weapon(new_weapon: Weapon) -> void:
	for child in get_children():
		child.queue_free()
	current_weapon = new_weapon.scene.instantiate() as Node3D
	add_child(current_weapon)
	current_weapon.position = new_weapon.position
	current_weapon.rotation_degrees = new_weapon.rotation
	current_weapon.scale = new_weapon.scale
