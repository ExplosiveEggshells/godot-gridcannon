class_name GameSaveData

var save_format : int
var game_state : String
var moves : int
var decks : Array

func _init():
	save_format = -1
	game_state = ""
	moves = 0
	decks = []
