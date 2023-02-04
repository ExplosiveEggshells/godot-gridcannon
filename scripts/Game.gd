extends Control

export(PackedScene) var card_scene
export(NodePath) var deck_grid

func _ready():
	GameManager.game_root = self

func CreateCards():
	var suit = 1
	var value = 1
	for i in 54:
		var next_spawn_pos = Vector2.ZERO
		var card_ID = str(suit) + "_" + str(value)
	
		var next_card = card_scene.instance()
		next_card.SetCard(suit, value)
		add_child(next_card)
		
		next_card.name = card_ID
		next_card.position = next_spawn_pos
		GameManager.card_dict[card_ID] = next_card
	
		value += 1
		if (value > 13):
			value = 1
			suit += 1
