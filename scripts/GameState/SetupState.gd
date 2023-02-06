extends GameState

func _ready():
	$FirstDrawTimer.connect("timeout", self, "draw_first_card")
	
	GameManager.connect("_relay_card_placement", self, "_on_card_placed")

func enter(_parms := {}) -> void:
	GameManager.clear_draw_receive_flags()
	
	GameManager.game_root.CreateCards()
	GameManager.deck_container.BuildGrid()
	
	for card in GameManager.card_dict.values:
		GameManager.move_card_to_deck(card, GameManager.deck_dict["main_deck"])
	
	$FirstDrawTimer.start()

func draw_first_card() -> void:
	var from_deck = GameManager.deck_dict["main_deck"]
	var to_deck = GameManager.deck_dict["next_card"]
	GameManager.draw_card_from_deck_to_deck(from_deck, to_deck)
	
	to_deck.drawable = true
