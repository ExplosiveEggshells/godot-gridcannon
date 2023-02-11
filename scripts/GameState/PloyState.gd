extends GameState

var useable_ploy_decks = []

func _ready() -> void:
	GameManager.connect("deck_reset", self, "_on_deck_reset")

func enter(_parms := {}) -> void:
	GameManager.clear_draw_receive_flags()
	
	useable_ploy_decks = GameManager.get_useable_ploys()
	
	if (useable_ploy_decks.size() == 0):
		GameManager.transition_to("Round")
		return
	
	for deck in GameManager.get_decks_of_type(DeckType.GRID_NUMBER):
		if (!deck.card_stack.empty()):
			deck.set_resettable(true)
	

func _on_deck_reset(deck):
	while (!deck.card_stack.empty()):
		GameManager.draw_card_deck_to_bottom_deck(deck, GameManager.deck_dict["main_deck"])
	
	deck.set_resettable(false)
	
	useable_ploy_decks[0].top_card().kill_card()
	
	GameManager.clear_draw_receive_flags()
	GameManager.transition_to("Round")
