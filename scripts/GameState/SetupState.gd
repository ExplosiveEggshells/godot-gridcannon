extends GameState

func _ready():
	$FirstDrawTimer.connect("timeout", self, "draw_first_card")

func enter(_parms := {}) -> void:
	sm.game_root.CreateCards()
	sm.deck_container.BuildGrid()
	for card_key in sm.card_dict:
		sm.move_card_to_deck(GameManager.card_dict[card_key], GameManager.deck_dict["main_deck"])
	
	$FirstDrawTimer.start()

func draw_first_card() -> void:
	var from_deck = GameManager.deck_dict["main_deck"]
	var to_deck = GameManager.deck_dict["next_card"]
	sm.draw_card_from_deck_to_deck(from_deck, to_deck)
	
	to_deck.drawable = true
