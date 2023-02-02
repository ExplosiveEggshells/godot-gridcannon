extends Position2D

export(float) var fly_speed = 30

var suit : int
var value : int
var face_texture : Resource
var back_texture : Resource

var desired_position = Vector2.ZERO
var card_sprite : Sprite

func _ready():
	card_sprite = $CardSprite

func _process(delta):
	pass
	
func SetCard(var _suit : int, var _value : int, var royal_color = Color.lightgoldenrod):
	suit = _suit
	value = _value
	
	print("res://assets/sprites/cards/card_" + str(suit) + "_" + str(value) + ".png")
	face_texture = load("res://assets/sprites/cards/card_" + str(suit) + "_" + str(value) + ".png")
	back_texture = GameManager.card_back
	$CardSprite.texture = face_texture

	
