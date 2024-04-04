extends Area2D
var world = get_parent().get_parent()
var texture = preload("res://Sprite/grass.jpg")
var entered = false
var exited = true
var money_per_sec = 5
var people = 2
var peoplemoneycost = 100
var food = 0


var controlling_player = -1



func on_area_mouse_entered():
	exited = false
	entered = true
	

func on_area_mouse_exited():
	exited = true
	entered = false
	



func amiselected():
	if get_parent().get_parent().selected == self:
		get_parent().set_color(Color.hex(0x53db78c5))
	else:
		if controlling_player !=-1: 
			get_parent().set_color(get_parent().get_parent().players[controlling_player].player_color)
		else: get_parent().set_color(Color.hex(0xb2db53c9))
		get_parent().texture_repeat = TEXTURE_REPEAT_ENABLED
		get_parent().texture_scale = Vector2(2, 2)
		get_parent().set_texture(texture)

func whileinhex():
	var area = self
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if entered == true and exited == false:
			get_parent().get_parent().selected = area
#			print(str(self))

func addmoney():
	if controlling_player != -1:
		get_parent().get_parent().players[controlling_player].money = get_parent().get_parent().players[controlling_player].money + (money_per_sec * people)
	await get_tree().create_timer(1).timeout
#	if get_parent().get_parent().selected == self:
#		print(str(get_parent().get_parent().players[controlling_player].money))
#		print(people)
	addmoney()


func debugmode():
	if Controll.debug_mode:
		get_parent().get_parent().labels[get_parent().get_parent().polygons.find(get_parent())].visible = true
	else: get_parent().get_parent().labels[get_parent().get_parent().polygons.find(get_parent())].visible = false

func _ready():
	addmoney()
func _process(delta):
	whileinhex()
	amiselected()
	debugmode()


