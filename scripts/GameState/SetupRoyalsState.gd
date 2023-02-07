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

func get_most_similar_deck(royal_card) -> Array:
	var number_decks = GameManager.get_decks_of_type(DeckType.GRID_NUMBER)
	number_decks.remove(4)		# Remove middle deck
	var max_num = 0
	var max_per_suit = [0, 0, 0, 0]
	var max_per_suit_cards = [0, 0, 0, 0]
	var greatest_in_similar_suit = null
	for card in number_decks:
		if (card.value > max_num):
			max_num = card.value
		if (card.suit == royal_card.suit):
			if (greatest_in_similar_suit == null || greatest_in_similar_suit.value < card.value):
				greatest_in_similar_suit = card
		elif (card.value > max_per_suit[card.suit-1]):
			max_per_suit[card.suit-1] = card.value
			max_per_suit_cards[card.suit-1] = card
	
	# Horrifying logic to select the 'closest' card to the royal
	# 1: Greatest card of the same suit as the royal
	if (greatest_in_similar_suit != null):
		return [greatest_in_similar_suit]
	
	# 2: Greatest card of similar color as the royal. It is possible to return two.
	# For black suits
	if ((royal_card.suit == 1 || royal_card.suit == 3) && (max_per_suit[0] != 0 || max_per_suit[2] != 0)):
		if (max_per_suit[0] == max_per_suit[2]):
			return [max_per_suit_cards[0], max_per_suit_cards[2]]
		elif (max_per_suit[0] > max_per_suit[2]):
			return [max_per_suit_cards[0]]
		else:
			return [max_per_suit_cards[2]]
	
	# For red suits
	elif ((royal_card.suit == 2 || royal_card.suit == 4) && (max_per_suit[1] != 0 || max_per_suit[3] != 0)):
		if (max_per_suit[1] == max_per_suit[3]):
			return [max_per_suit_cards[1], max_per_suit_cards[3]]
		elif (max_per_suit[1] > max_per_suit[3]):
			return [max_per_suit_cards[1]]
		else:
			return [max_per_suit_cards[3]]
	# 3: Greatest card of any suit
	else:
		for deck in max_per_suit_cards:
			if (deck.value == max_num):
				return [deck]
	
	return [max_per_suit_cards[0]]	# Unreachable

func get_adjacent_royal_decks(deck):
	var adjacent_royal_decks = []
	
	var next_test = evaluate_royal_deck(deck, 1, 0)
	if (next_test != null):
		adjacent_royal_decks.append(next_test)
		
	next_test = evaluate_royal_deck(deck, -1, 0)
	if (next_test != null):
		adjacent_royal_decks.append(next_test)
		
	next_test = evaluate_royal_deck(deck, 0, -1)
	if (next_test != null):
		adjacent_royal_decks.append(next_test)
	
	next_test = evaluate_royal_deck(deck, 0, 1)
	if (next_test != null):
		adjacent_royal_decks.append(next_test)
	
func evaluate_royal_deck(deck, delta_x, delta_y):
	var target_deck = GameManager.grid_decks[deck.grid_y + delta_y][deck.grid_x + delta_x]
	if (target_deck.deck_type == DeckType.GRID_ROYAL):
		return target_deck
	return null
