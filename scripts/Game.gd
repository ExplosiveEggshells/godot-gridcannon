extends Control

var rng = RandomNumberGenerator.new()
export(PackedScene) var card_scene
export(Color) var royal_color

func _ready():
	rng.randomize()
#	for i in 25:
#		var suit = rng.randi_range(1, 4)
#		var value = rng.randi_range(1, 13)
#		var c = card_scene.instance()
#		c.SetCard(suit, value)
#		$GridContainer.add_child(c)
