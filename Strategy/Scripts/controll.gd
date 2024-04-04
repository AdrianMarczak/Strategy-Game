extends Node2D

var playerone = Player.new(Color.hex(0xafd420ff))
var playertwo = Player.new(Color.hex(0xafd420ff))

var coldeselected = {1 : playerone.colordeselected, 2 : playertwo.colordeselected}
var colselected = {1 : playerone.colorselected, 2 : playertwo.colorselected}
var controll = {0 : 1, 1 : 2}
var debug_mode = false
var hex_whole_map = false


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	controls()

func controls():
	if Input.is_action_just_pressed("Exit"): #exits the game
		get_tree().quit()
	if Input.is_action_just_pressed("debug_mode"):
		if debug_mode:
			debug_mode = false
		else: debug_mode = true
	if Input.is_action_just_pressed("HexWholeMap"):
		if hex_whole_map:
			hex_whole_map = false
		else: hex_whole_map = true


