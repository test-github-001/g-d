extends CharacterBody2D


enum STATES {
	SQUARE,
	DIE
}

@export var INIT_STATE: STATES = 0
var STATE = INIT_STATE
var speed = 1000
var gravity = 100
var jump = 2000
var on_ground = false

@onready var ImageState0: Node2D = $imgs/mode0/img

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


func _on_damage_area_body_entered(body):
	if body.is_in_group("damage"):
		print('больно')
