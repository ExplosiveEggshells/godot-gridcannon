extends Control

export(PackedScene) var card_scene
var rng = RandomNumberGenerator.new()

func _ready():
	var next_card = card_scene.instance()
	next_card.SetCard(1, 3)
	add_child(next_card)
	
	$VirtualDeck.PushCard(next_card)

