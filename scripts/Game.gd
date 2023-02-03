extends Control

export(PackedScene) var card_scene
var rng = RandomNumberGenerator.new()

var suit = 1
var value = 1

func _ready():
	rng = RandomNumberGenerator.new()



func _on_Timer_timeout():
	var next_spawn_pos = Vector2.ZERO
	next_spawn_pos.x = rng.randi_range(0, rect_size.x)
	next_spawn_pos.y = rng.randi_range(0, rect_size.y)
	
	var next_card = card_scene.instance()
	next_card.SetCard(suit, value)
	add_child(next_card)
	
	next_card.position = next_spawn_pos
	
	$VirtualDeck.PushCard(next_card)
	
	value += 1
	if (value > 13):
		value = 1
		suit += 1
	
	if (suit < 5):
		$Timer.start()
