extends CenterContainer

@export var player_controller: CharacterBody3D
@export var dot_radius := 2.0
@export var dot_color := Color.AZURE
@export var reticle_speed := 0.5
@export var reticle_spread := 3.0

@onready var top_line :=  $Top as Line2D
@onready var bot_line :=  $Bot as Line2D
@onready var left_line :=  $Left as Line2D
@onready var right_line :=  $Right as Line2D


func _ready() -> void:
	top_line.default_color = dot_color
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2(0, 0), dot_radius, dot_color)


func _process(delta) -> void:
	update_reticle()


func update_reticle() -> void:
	var distance := player_controller.get_real_velocity().length()
	top_line.position = lerp(top_line.position, Vector2(0, -distance * reticle_spread), reticle_speed)
	bot_line.position = lerp(bot_line.position, Vector2(0, distance * reticle_spread), reticle_speed)
	left_line.position = lerp(left_line.position, Vector2(-distance * reticle_spread, 0), reticle_speed)
	right_line.position = lerp(right_line.position, Vector2(distance * reticle_spread, 0), reticle_speed)
