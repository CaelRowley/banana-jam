class_name Player
extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 10.0
@export var mouse_sensitivity := 0.5
@export var tilt_lower_limit := -90.0
@export var tilt_upper_limit := 90.0

var _rotation_input: float
var _tilt_input: float
var _mouse_rotation: Vector3

var gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float

@onready var camera := %Camera3D as Camera3D
@onready var tilt_lower_limit_rad := deg_to_rad(tilt_lower_limit)
@onready var tilt_upper_limit_rad := deg_to_rad(tilt_upper_limit)
@onready var weapon_rig := %WeaponRig

func _physics_process(delta: float) -> void:
	_update_camera(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * speed, speed/10.0)
			velocity.z = move_toward(velocity.z, direction.z * speed, speed/10.0)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_event := event as InputEventMouseMotion
		_rotation_input = -mouse_event.relative.x * mouse_sensitivity
		_tilt_input = -mouse_event.relative.y * mouse_sensitivity
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	if event.is_action_pressed("1"):
		weapon_rig.load_weapon(load("res://props/weapons/pickaxe/pickaxe.tres"))
	
	if event.is_action_pressed("2"):
		weapon_rig.load_weapon(load("res://props/weapons/pickaxe/pickaxe2.tres"))


func _update_camera(delta: float) -> void:
	_mouse_rotation.x += _rotation_input * delta
	_mouse_rotation.y += _tilt_input * delta
	_mouse_rotation.y = clampf(_mouse_rotation.y, tilt_lower_limit_rad, tilt_upper_limit_rad)

	global_transform.basis = Basis.from_euler(Vector3(0.0, _mouse_rotation.x, 0.0))
	camera.transform.basis = Basis.from_euler(Vector3(_mouse_rotation.y, 0.0, 0.0))

	_rotation_input = 0.0
	_tilt_input = 0.0
