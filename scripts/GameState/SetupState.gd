extends GameState

var draw_pause_timer
var grid_decks_placed = 0

func _ready():
	draw_pause_timer = $DrawPauseTimer
	draw_pause_timer.one_shot = false
	
	$FirstDrawTimer.connect("timeout", self, "draw_card")
#	GameManager.connect("card_placed", self, "_on_card_placed")

func enter(_parms := {}) -> void:
	var main_deck = GameManager.main_deck
	GameManager.clear_draw_receive_flags()
	
	GameManager.game_root.CreateCards()
	GameManager.deck_container.BuildGrid()
	
	
	for card in GameManager.card_dict.values():
		GameManager.move_card_to_deck(card, main_deck)
	
	main_deck.shuffle()
	
	$FirstDrawTimer.start()

func draw_card() -> void:
	var from_deck = GameManager.main_deck
	var to_deck = GameManager.deck_dict["next_card"]
	
	var card = from_deck.top_card()
	
	GameManager.draw_card_from_deck_to_deck(from_deck, to_deck)
	
	draw_pause_timer.start()
	yield(draw_pause_timer, "timeout")
	
	match card.card_type:
		CardType.NUMBER:
			handle_number_draw(card)
		CardType.ROYAL:
			handle_royal_draw(card)
		CardType.PLOY:
			handle_ploy_draw(card)

func handle_number_draw(card) -> void:
	var number_decks = GameManager.get_decks_of_type(DeckType.GRID_NUMBER)
	
	number_decks.remove(4)		# Remove the middle square
	
	for deck in number_decks:
		var top_card = deck.top_card()
		if (top_card == null):
			deck.set_receptible(true)
	
	GameManager.deck_dict["next_card"].set_drawable(true)
	
	yield(GameManager, "card_placed")
	GameManager.clear_draw_receive_flags()
	
	grid_decks_placed += 1
	
	if (grid_decks_placed >= 8):
		GameManager.transition_to("SetupRoyals")
	else:
		draw_card()

func handle_royal_draw(card) -> void:
	GameManager.move_card_to_deck(card, GameManager.grid_decks[2][2])
	
	draw_card()

func handle_ploy_draw(card) -> void:
	var target_deck = GameManager.deck_dict["ploy_" + card.name]
	GameManager.move_card_to_deck(card, target_deck)
	
	draw_card()
