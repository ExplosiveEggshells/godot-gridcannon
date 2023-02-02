extends GridContainer

export(PackedScene) var deck_scene

export(Color) var default_deck_color = Color.white
export(Color) var royal_color_1 = Color.darkred
export(Color) var royal_color_2 = Color.purple


func _ready():
	BuildGrid()

func BuildGrid():
	for y in 5:
		for x in 5:
			var card_color = default_deck_color
			if (y == 0 || y == 4):
				card_color = royal_color_1 if x % 2 == 0 else royal_color_2
			else:
				if (x == 0 || x == 4):
					card_color = royal_color_1 if y % 2 == 0 else royal_color_2
			var next_deck = deck_scene.instance()
			next_deck.modulate = card_color
			add_child(next_deck)
			next_deck.UpdatePivot()
