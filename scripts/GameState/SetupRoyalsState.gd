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
	var receptible_decks = GameManager.get_royal_receptible_decks(next_royal)
	
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
