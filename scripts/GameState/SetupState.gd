extends GameState

func _ready():
	$FirstDrawTimer.connect("timeout", self, "draw_first_card")

func enter(_parms := {}) -> void:
	sm.game_root.CreateCards()
	for card_key in sm.card_dict:
		sm.MoveCardToDeck(card_key, "main_deck")
	
	$FirstDrawTimer.start()

func draw_first_card() -> void:
	sm.draw_card_from_deck_to_deck("main_deck", "next_card")
