extends Position2D


var suit : int
var value : int
var face_texture : Resource
var back_texture : Resource

var desired_position = Vector2.ZERO
var card_sprite : Sprite

var fly_lerp_rate = 1.8
var fly_budge = 0.05

func _ready():
	card_sprite = $CardSprite

func _process(delta):
	if (position != desired_position):
		position = position.linear_interpolate(desired_position, fly_lerp_rate * delta)
		position = position.move_toward(desired_position, fly_budge)
	
func SetCard(var _suit : int, var _value : int, var royal_color = Color.lightgoldenrod):
	suit = _suit
	value = _value

	face_texture = load("res://assets/sprites/cards/card_" + str(suit) + "_" + str(value) + ".png")
	back_texture = GameManager.card_back
	$CardSprite.texture = face_texture

func SetFaceUp(var is_face_up : bool):
	$CardSprite.texture = face_texture if is_face_up else back_texture
