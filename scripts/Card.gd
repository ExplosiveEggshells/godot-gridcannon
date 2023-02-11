extends Position2D

var follow_mouse = false

var suit : int
var value : int
var face_texture : Resource
var back_texture : Resource

var desired_position = Vector2.ZERO
var desired_scale = Vector2.ONE
var card_sprite : Sprite

var fly_lerp_rate = 12.5
var fly_budge = 0.05

var assigned_vdeck = null
var deck_scanner_area = null
var card_type

var alive = true


func _ready():
	card_sprite = $CardSprite
	deck_scanner_area = $DeckScannerArea

func _process(delta):
	if (!follow_mouse):
		if (assigned_vdeck != null):
			desired_position = assigned_vdeck.global_position
			desired_scale = assigned_vdeck.global_scale
	else:
		desired_position = get_viewport().get_mouse_position()
		card_sprite.z_index = 60
		if (!Input.is_action_pressed("pointer_select")):
			end_mouse_follow()
			
	if (position != desired_position):
		position = position.linear_interpolate(desired_position, fly_lerp_rate * delta)
		position = position.move_toward(desired_position, fly_budge)
		
	scale = scale.linear_interpolate(desired_scale, fly_lerp_rate * delta)
	
func SetCard(var _suit : int, var _value : int):
	suit = _suit
	value = _value

	face_texture = load("res://assets/sprites/cards/card_" + str(suit) + "_" + str(value) + ".png")
	back_texture = GameManager.card_back
	$CardSprite.texture = face_texture

func set_face_up(var is_face_up : bool):
	$CardSprite.texture = face_texture if is_face_up else back_texture

func kill_card():
	alive = false
	$CardSprite.modulate = Color.darkred

func end_mouse_follow():
	follow_mouse = false
	var nearby_decks : Array = deck_scanner_area.get_overlapping_areas()
	
	var closest_receptible_deck = null
	var closest_receptible_deck_dist = 999999
	
	for deck_area in nearby_decks:
		var vdeck = deck_area.get_parent().get_node("VirtualDeck")
		if (vdeck.receptible):
			var distance = global_position.distance_to(vdeck.global_position)
			if (distance < closest_receptible_deck_dist):
				closest_receptible_deck = vdeck
				closest_receptible_deck_dist = distance
	
	if (closest_receptible_deck != null):
		GameManager.move_card_to_deck(self, closest_receptible_deck)
		GameManager._relay_card_placement(self, closest_receptible_deck)
