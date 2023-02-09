extends GameState

var next_card_deck
var middle_deck

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
	middle_deck = GameManager.grid_decks[2][2]
	
	$EnterWaitTimer.start()
	yield($EnterWaitTimer, "timeout")
	
	prepare_next_royal()

func move_royal_to_hand() -> void:
	GameManager.draw_card_from_deck_to_deck(middle_deck, next_card_deck)
	

func prepare_next_royal() -> void:
	GameManager.clear_draw_receive_flags()
	
	$DrawPauseTimer.start()
	yield($DrawPauseTimer, "timeout")
	
	if (middle_deck.card_stack.empty()):
		GameManager.transition_to("Round")
		return
	
	move_royal_to_hand()
	
	var next_royal = next_card_deck.top_card()
	var deck_priorities = get_deck_priorities(next_royal)
	var receptible_decks = []
	
	var match_val = -1		# Once set to a non -1 value, all further deck's must have this priority to be considered.
	
	for i in (deck_priorities.size()-1):
		if (match_val != -1 && deck_priorities[i][1] != match_val):
			break
		
		var valid_adjacent_decks = get_adjacent_royal_decks(deck_priorities[i][0])
		if (!valid_adjacent_decks.empty()):
			receptible_decks.append_array(valid_adjacent_decks)
			match_val = deck_priorities[i][1]
		
	# No receptible decks should be logically impossible.
	assert(receptible_decks.size() != 0)
	
	# If there is only one possible location, move the card there automatically.
	# Otherwise, wait for the player to choose.
	if (receptible_decks.size() == 1):
		GameManager.draw_card_from_deck_to_deck(next_card_deck, receptible_decks[0])
	else:
		for deck in receptible_decks:
			deck.set_receptible(true)
		
		next_card_deck.set_drawable(true)
	
		yield(GameManager, "card_placed")
	
	prepare_next_royal()

func get_deck_priorities(royal_card):
	var number_decks = GameManager.get_decks_of_type(DeckType.GRID_NUMBER)
	number_decks.remove(4)		# Remove middle deck
	
	var deck_priority_tuples = []
	
	# Generate 'priority' scores per deck. Highest priority is the best
	# candidate for the royal.
	# Same suit: +20
	# Not suit, but same color: +10
	# + Card's numeric value.
	for deck in number_decks:
		var priority = 0
		var top_card = deck.top_card()
		
		if (top_card.suit == royal_card.suit):						# Same suit
			priority = 20	
		elif (royal_card.suit == 1 || royal_card.suit == 3):		# Black suits
			if (top_card.suit == 1 || top_card.suit == 3):
				priority = 10
		elif (royal_card.suit == 2 || royal_card.suit == 4):		# Red suits
			if (top_card.suit == 2 || top_card.suit == 4):
				priority = 10
		
		priority += top_card.value
		deck_priority_tuples.append([deck, priority])
	
	deck_priority_tuples.sort_custom(self, "sort_priority_decks")
	return deck_priority_tuples

func sort_priority_decks(a, b):
	return (a[1] > b[1])
		

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
	
	return adjacent_royal_decks

func evaluate_royal_deck(deck, delta_x, delta_y):
	var target_deck = GameManager.grid_decks[deck.grid_y + delta_y][deck.grid_x + delta_x]
	if (target_deck.deck_type == DeckType.GRID_ROYAL && target_deck.card_stack.empty()):
		return target_deck
	return null
