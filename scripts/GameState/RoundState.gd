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
	
	var received_deck = yield(GameManager, "card_placed")[0]
	
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
	pass
