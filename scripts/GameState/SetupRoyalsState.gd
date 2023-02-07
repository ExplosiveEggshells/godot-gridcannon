extends GameState

var next_card_deck

func _on_card_placed(card, deck) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_parms := {}) -> void:
	next_card_deck = GameManager.deck_dict["next_card"]
	
	$MoveRoyalsTimer.start()
	yield($MoveRoyalsTimer, "timeout")
	
	var middle_deck = GameManager.grid_decks[2][2]
	var main_deck = GameManager.deck_dict["next_card"]
	GameManager.draw_all_cards_from_deck_to_deck(middle_deck, main_deck)

func prepare_next_royal() -> void:
	if (next_card_deck.card_stack.empty()):
		GameManager.transition_to("Round")
		return
	
	var next_royal = next_card_deck.top_card()

func get_most_similar_deck(royal_card):
	var number_decks = GameManager.get_decks_of_type(DeckType.GRID_NUMBER)
	var max_per_suit = [0, 0, 0, 0]
	var max_per_suit_cards = [0, 0, 0, 0]
	var greatest_in_similar_suit = null
	for card in number_decks:
		if (card.suit == royal_card.suit):
			if (greatest_in_similar_suit == null || greatest_in_similar_suit.value < card.value):
				greatest_in_similar_suit = card
		elif (card.value > max_per_suit[card.suit-1]):
			max_per_suit[card.suit-1] = card.value
			max_per_suit_cards[card.suit-1] = card
	
	if (greatest_in_similar_suit != null):
		return greatest_in_similar_suit
	
	
