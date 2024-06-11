extends CenterContainer

@export var DOT_RADIUS := 2.0
@export var DOT_COLOR := Color.AZURE

@onready var top_line :=  $Top as Line2D
@onready var bot_line :=  $Bot as Line2D
@onready var left_line :=  $Left as Line2D
@onready var right_line :=  $Right as Line2D


func _ready():
	top_line.default_color = DOT_COLOR
	queue_redraw()


func _draw():
	draw_circle(Vector2(0, 0), DOT_RADIUS, DOT_COLOR)
