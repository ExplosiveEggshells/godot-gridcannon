extends StateMachine

signal card_placed(card, vdeck)

var card_back = preload("res://assets/sprites/cards/card_back.png")

var deck_dict = {}
var card_dict = {}

var grid_decks = []

var deck_container = null
var game_root = null
var main_deck = null

var rng : RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

# Registers the card to a new deck, changing it's desired position and potentially
# deregistering it from the previous deck if applicable. 
func move_card_to_deck(var card, var deck):
	
	if (card.assigned_vdeck != null):
		card.assigned_vdeck.RemoveCard(card)
	
	deck.PushCard(card)

func draw_card_from_deck_to_deck(var source_deck, var target_deck):
	var popped_card = source_deck.PopCard(true)
	
	move_card_to_deck(popped_card, target_deck)

func draw_all_cards_from_deck_to_deck(source_deck, target_deck) -> void:
	while(!source_deck.card_stack.empty()):
		draw_card_from_deck_to_deck(source_deck, target_deck)

func get_decks_of_type(type) -> Array:
	var decks = []
	for y in 5:
		for x in 5:
			if (grid_decks[x][y].deck_type == type):
				decks.append(grid_decks[x][y])
	
	return decks

func clear_draw_receive_flags() -> void:
	for deck in deck_dict.values():
		deck.set_receptible(false)
		deck.set_drawable(false)

func _relay_card_placement(var card, var vdeck) -> void:
	emit_signal("card_placed", card, vdeck)
	
## PLACEMENT LOGIC ##
func get_valid_number_placements(card) -> Array:
	var number_decks = get_decks_of_type(DeckType.GRID_NUMBER)
	var valid_decks = []
	
	for deck in number_decks:
		if (deck.card_stack.empty()):
			valid_decks.append(deck)
			continue
		
		var top_card = deck.top_card()
		if (top_card.value <= card.value):
			valid_decks.append(deck)
	
	return valid_decks

func get_royal_receptible_decks(royal_card):
	var deck_priorities = get_deck_priorities(royal_card)
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
	
	return receptible_decks
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
