extends CharacterBody2D


enum STATES {
	SQUARE,
	PLANE,
	DIE
}

@export var INIT_STATE: STATES = 0
var STATE = INIT_STATE
var speed = 1000
var gravity = 100
var jump = 2000
var on_ground = false

@onready var statesImages = [$imgs/mode0, $imgs/mode1]
@onready var statesCollision = [$mode0, $mode1]
@onready var statesDamage = [$damage/damage_area/mode0, $damage/damage_area/mode1]

@onready var ImageState0: Node2D = $imgs/mode0/img


func change_state(state):
	for i in range(2):
		statesImages[i].visible = false
		statesCollision[i].disabled = true
		statesDamage[i].disabled = true
	
	if  state != STATES.DIE:
		statesImages[state].visible = true
		statesCollision[state].disabled = false
		statesDamage[state].disabled = false
	STATE = state
	
func mode0(delta):
	velocity.x = speed
	velocity.y += gravity
	if Input.is_action_pressed("jump"):
		if $ground.is_colliding():
			velocity.y = -jump 

	if not $ground.is_colliding() and on_ground:
		ImageState0.rotation += 9*delta
		
	if $ground.is_colliding():
		on_ground = true
		var leveling = snapped(ImageState0.rotation, PI/2)
		ImageState0.rotation = leveling
		
	move_and_slide()


	
func _physics_process(delta):
	match STATE:
		0: mode0(delta)
		1: mode1(delta)
	if velocity.x == 0:
		death()

func death():
	$AnimationDeath.play("death")
	if STATE != STATES.DIE:
		$boom.play()
	change_state(STATES.DIE)



func mode1(delta):
	var vertical_speed = 2000
	var gravity = -50
	velocity.x = speed
	
	if not Input.is_action_pressed("jump"):
		gravity = -gravity 
	velocity.y = clamp(velocity.y + gravity, -vertical_speed, vertical_speed)
	var rotation = (velocity.y / vertical_speed) 
	$imgs/mode1.rotation_degrees = rotation * 60

	move_and_slide()

func _on_damage_area_body_entered(body):
	if body.is_in_group("damage"):
		death()

func restart():
	position = Vector2()
	change_state(INIT_STATE)
	var bg_node = get_tree().current_scene.get_node("ParallaxBackground/ParallaxLayer/bgs")
	bg_node.modulate = Color("#00b1f5")
	var music = get_tree().current_scene.get_node("bg")
	music.stream = preload("res://assets/sounds/Zardonic feat. Mikey Rukus - Bring It On.mp3")
	music.play()
