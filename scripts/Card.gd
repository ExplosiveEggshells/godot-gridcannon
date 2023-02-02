extends TextureButton

var suit : int
var value : int
var face_texture : Resource
var back_texture : Resource

func SetCard(var _suit : int, var _value : int, var royal_color = Color.lightgoldenrod):
	suit = _suit
	value = _value
	
	print("res://assets/sprites/cards/card_" + str(suit) + "_" + str(value) + ".png")
	face_texture = load("res://assets/sprites/cards/card_" + str(suit) + "_" + str(value) + ".png")
	back_texture = GameManager.card_back
	set_normal_texture(face_texture)
	
	if (value >= 11):
		modulate = royal_color

func _ready():
	pass
