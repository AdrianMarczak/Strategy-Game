extends Node2D

var selected : Object


var mapSize = Vector2(5, 5)
var hexRadius = 50
var xOffset = hexRadius * 1.5
var yOffset = hexRadius * 1.73
var polygons = []
var labels = []

var hexagonwholemapid = []
var players = [Player.new(Color.hex(0x0c62edff)),Player.new(Color.hex(0xbf420fff))]
var areaindex = []
var currenttile: Object
var active_player = 0

var regioncost = 1000



@onready var money = get_node("Control/GridContainer/MoneyContainer/Money")
@onready var people = get_node("Control/GridContainer/PeopleContainer/PeopleNumber")

func _ready():
	generateHexagonalMap()
#	polygons[91].set_color(Color.DARK_RED)
	for i in range(len(polygons)):
		labels.append(Label.new())
		polygons[i].add_child(labels[i])
		labels[i].text = str(i)
		
	printhexes()

	polygons[0+(len(polygons)/4)].set_color(players[0].colordeselected)
	polygons[len(polygons)-(len(polygons)/4)].set_color(players[1].colordeselected)
	
	$Control.visible = false
	for i in range(len(hexagonwholemapid)):
		hexagonwholemapid[i].visible = false
	changelabel()
	
func generateHexagonalMap():
	for x in range(int(mapSize.x * 4)):
		for y in range(int(mapSize.y * 2)):
			var position = Vector2((x-mapSize.x * 1.9) * xOffset, (y - mapSize.y ) * yOffset)
			if x % 2 == 1:
				position.y += yOffset / 2  # Offset every odd row
			var randommap = randi_range(0,100)
			if randommap > 40:
				var hexagon = generateHexagon(position)
				add_child(hexagon)
			hexagonwholemapid.append(Label.new())
			add_child(hexagonwholemapid[len(hexagonwholemapid) - 1])
			hexagonwholemapid[len(hexagonwholemapid) - 1].text = str(len(hexagonwholemapid) - 1)
			hexagonwholemapid[len(hexagonwholemapid) - 1].position = position

func generateHexagon(position):
	var hexagon = Polygon2D.new()
	hexagon.polygon = draw_hex()
	hexagon.position = position
	polygons.append(hexagon)

	var area = Area2D.new()
	var collisionShape = CollisionPolygon2D.new()

	area.add_child(collisionShape)
	hexagon.add_child(area)
	collisionShape.polygon = hexagon.polygon
	areaindex.append(area)
	area.script = preload("res://Scripts/currentarea.gd")
	area.mouse_entered.connect(Callable(area ,"on_area_mouse_entered"))
	area.mouse_exited.connect(Callable(area ,"on_area_mouse_exited"))


	return hexagon


func draw_hex():
	var points = PackedVector2Array()
	var pointCount = 6

	for i in range(pointCount):
		var angle = deg_to_rad(i * 60.0)
		var x = hexRadius * cos(angle)
		var y = hexRadius * sin(angle)
		points.push_back(Vector2(x, y))

	return points

func changelabel():
	for y in range(len(labels)):
		for i in range(len(hexagonwholemapid)):
			if polygons[y].position == hexagonwholemapid[i].position:
				labels[y].text = hexagonwholemapid[i].text


func _process(delta):
#	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#		print(str(selected))
	if selected != null:
		if selected.controlling_player == active_player:
			money.text = str(players[active_player].money)
			people.text = str(selected.people)
	showmenu()
	deselect()
	buyregionvisible()

#	print("true")
	hexidvisible()


func hexidvisible():
	for i in range(len(hexagonwholemapid)):
		if Controll.hex_whole_map:
			hexagonwholemapid[i].visible = true
		else: hexagonwholemapid[i].visible = false

func printhexes():
	for i in range(len(players[active_player].hexes)):
		print(str(players[active_player].hexes[i]))
	await get_tree().create_timer(1).timeout
	printhexes()

func deselect():
	if Input.is_action_just_pressed("deselect"):
		selected = null

func showmenu():
	if selected == null or selected.controlling_player != active_player:
		get_node("Control").visible = false
	else: get_node("Control").visible = true


func buyregionvisible():
	if selected != null:
		if selected.controlling_player == -1:
				
			if players[active_player].money >= regioncost:
				if len(players[active_player].hexes) != 0:
					for i in range(len(players[active_player].hexes)):
						if players[active_player].hexes[i]+10 == int(labels[polygons.find(selected.get_parent())].text) or players[active_player].hexes[i] -10 == int(labels[polygons.find(selected.get_parent())].text) or players[active_player].hexes[i]+9 == int(labels[polygons.find(selected.get_parent())].text) or players[active_player].hexes[i] - 11 == int(labels[polygons.find(selected.get_parent())].text) or players[active_player].hexes[i] + 1 == int(labels[polygons.find(selected.get_parent())].text) or players[active_player].hexes[i] - 1 == int(labels[polygons.find(selected.get_parent())].text):
							$BuyRegion.visible = true
						else: $BuyRegion.visible = false
				else:$BuyRegion.visible = true

			elif selected.controlling_player != -1: 
				$BuyRegion.visible = false
			else: $BuyRegion.visible = false
				
		else: $BuyRegion.visible = false
	else: $BuyRegion.visible = false

func _on_button_pressed():
	if selected != null:
		if players[active_player].money >= selected.peoplemoneycost:
			selected.people = selected.people+ 1
			players[active_player].money = players[active_player].money-selected.peoplemoneycost


func _on_option_button_item_selected(index):
	active_player = index


func _on_buy_region_pressed():
	selected.controlling_player = active_player
	players[active_player].hexes.append(int(labels[polygons.find(selected.get_parent())].text))
	players[active_player].money = players[active_player].money - regioncost
