extends StateMachine

var card_back = preload("res://assets/sprites/cards/card_back.png")

var deck_dict = {}
var card_dict = {}

var grid_decks = []

var deck_container = null
var game_root = null

# Registers the card to a new deck, changing it's desired position and potentially
# deregistering it from the previous deck if applicable. 
func move_card_to_deck(var card, var deck):
	
	if (card.assigned_vdeck != null):
		card.assigned_vdeck.RemoveCard(card)
	
	deck.PushCard(card)

func draw_card_from_deck_to_deck(var source_deck, var target_deck):
	var popped_card = source_deck.PopCard(true)
	
	move_card_to_deck(popped_card, target_deck)
