extends GridContainer

export(PackedScene) var deck_scene

export(Color) var default_deck_color = Color.white
export(Color) var royal_color_1 = Color.darkred
export(Color) var royal_color_2 = Color.purple


func _ready():
	GameManager.deck_container = self

func BuildGrid():
	for y in 5:
		GameManager.grid_decks.append([])
		for x in 5:
			var card_color = default_deck_color
			var deck_type = DeckType.GRID_NUMBER
			
			var deck_name = "GridDeck" + str(x) + "_" + str(y)
			if (y == 0 || y == 4):
				card_color = royal_color_1 if x % 2 == 0 else royal_color_2
				deck_type = DeckType.GRID_ROYAL
			else:
				if (x == 0 || x == 4):
					card_color = royal_color_1 if y % 2 == 0 else royal_color_2
					deck_type = DeckType.GRID_ROYAL
			
			var next_deck = deck_scene.instance()
			next_deck.modulate = card_color
			add_child(next_deck)
			
			next_deck.name = deck_name
			next_deck.deck_name = deck_name
			next_deck.virtual_deck.deck_type = deck_type
			GameManager.grid_decks[y].append(next_deck.virtual_deck)
			next_deck.UpdatePivot()
