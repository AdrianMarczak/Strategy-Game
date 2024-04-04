class_name Player
extends Node

var player_color: Color
var colordeselected: Color
var colorselected: Color
var money: int = 2000
var people: int
var player_name: String
var hexes = []

func _init( color):
	self.player_color = color


func get_colordeselected():
	return colordeselected

func get_colorselected():
	return colorselected

