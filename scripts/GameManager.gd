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
