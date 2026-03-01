extends Area2D

enum STATES {
	SQUARE,
	PLANE,
	DIE
}
@export var STATE: STATES = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.change_state(STATE)
		_change_background_color(STATE)
		_change_music(STATE)

func _change_background_color(state):
	# путь до твоего Node2D внутри ParallaxBG
	var bg_node = get_tree().current_scene.get_node("ParallaxBackground/ParallaxLayer/bgs")

	match state:
		STATES.SQUARE:
			bg_node.modulate = Color("#00b1f5") # голубой
		STATES.PLANE:
			bg_node.modulate = Color("#37eb26") # салатовый
		STATES.DIE:
			bg_node.modulate = Color("#554d58") # серый
			

func _change_music(state):
	var music = get_tree().current_scene.get_node("bg")

	match state:
		STATES.PLANE:
			music.stream = preload("res://assets/sounds/BoomKitty_-_Power_Trip._GEOMETRY_DASH_versiya_v_igre_(SkySound.cc).mp3")
	music.play()
