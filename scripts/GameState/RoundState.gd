extends GameState

var main_deck
var hand_deck

func _on_card_placed(card, deck) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_parms := {}) -> void:

	
	main_deck = GameManager.main_deck
	hand_deck = GameManager.deck_dict["next_card"]
	
	draw_card()

func draw_card() -> void:
	GameManager.clear_draw_receive_flags()
	if (hand_deck.card_stack.empty()):
		if (main_deck.card_stack.empty()):
			pass
			# Fail state!		
		GameManager.draw_card_from_deck_to_deck(main_deck, hand_deck)
	
	var next_card = hand_deck.top_card()
	match (next_card.card_type):
		CardType.NUMBER:
			handle_number_placement(next_card)
		CardType.ROYAL:
			handle_royal_placement(next_card)
		CardType.PLOY:
			handle_ploy_draw(next_card)
	

func handle_number_placement(card):
	var receptible_decks = GameManager.get_valid_number_placements(card)
	
	for deck in receptible_decks:
		deck.set_receptible(true)
	
	hand_deck.set_drawable(true)
	
	var received_deck = yield(GameManager, "card_placed")[1]
	
	if (received_deck != GameManager.grid_decks[2][2]):
		royal_kill_attempt(received_deck)
	
	draw_card()
	

func handle_royal_placement(card):
	var receptible_decks = GameManager.get_royal_receptible_decks(card)
	
	# If there is only one possible location, move the card there automatically.
	# Otherwise, wait for the player to choose.
	if (receptible_decks.size() == 1):
		GameManager.draw_card_from_deck_to_deck(hand_deck, receptible_decks[0])
	else:
		for deck in receptible_decks:
			deck.set_receptible(true)
		
		hand_deck.set_drawable(true)
	
		yield(GameManager, "card_placed")
	
	draw_card()
	
func handle_ploy_draw(card):
	var target_deck = GameManager.deck_dict["ploy_" + card.name]
	GameManager.draw_card_from_deck_to_deck(hand_deck, target_deck)
	
	draw_card()

func royal_kill_attempt(seed_deck):
	try_payload(seed_deck, 1, 0)
	try_payload(seed_deck, -1, 0)
	try_payload(seed_deck, 0, 1)
	try_payload(seed_deck, 0, -1)

func try_payload(seed_deck, delta_x, delta_y):
	var length = 0
	var payload_strength = 0
	var payload_type = 2
	
	var xi = seed_deck.grid_x + delta_x
	var yi = seed_deck.grid_y + delta_y
	
	var last_card = null
	
	var current_deck = GameManager.grid_decks[xi][yi]
	
	while (current_deck.deck_type != DeckType.GRID_ROYAL):
		if (current_deck.card_stack.empty()):
			return
		var card = current_deck.top_card()
		payload_strength += card.value
		
		if (last_card != null):
			payload_type = GameManager.get_card_suit_similarity(last_card, card)
	
		last_card = card
		xi += delta_x
		yi += delta_y
		
		current_deck = GameManager.grid_decks[xi][yi]
		length += 1

	if (current_deck.card_stack.empty() || !current_deck.top_card().alive):
		return

	if (length == 2):
		var royal_card = current_deck.top_card()
		print("Seed: " + str(seed_deck.grid_x) + ", " + str(seed_deck.grid_y))
		print("Direction: " + str(delta_x) + ", " + str(delta_y))
		print("Kill attempt vs " + royal_card.name + " | strength: " + str(payload_strength) + " | type: " + str(payload_type))
		if (payload_type >= royal_card.value - 11 && payload_strength >= royal_card.value):
			GameManager.kill_royal(royal_card)







