extends StateMachine

var card_back = preload("res://assets/sprites/cards/card_back.png")

var deck_dict = {}
var card_dict = {}

var deck_container = null
var game_root = null

# Registers the card to a new deck, changing it's desired position and potentially
# deregistering it from the previous deck if applicable. 
func MoveCardToDeck(var card_ID, var target_deck_ID):
	var card = card_dict[card_ID]
	var deck = deck_dict[target_deck_ID]
	
	if (card.assigned_vdeck != null):
		card.assigned_vdeck.RemoveCard(card)
	
	deck.PushCard(card)

func draw_card_from_deck_to_deck(var source_deck_ID, var target_deck_ID):
	var src_deck = deck_dict[source_deck_ID]
	
	assert(src_deck.card_stack.size() != 0)

	var popped_card = src_deck.PopCard(false)
	
	MoveCardToDeck(popped_card, target_deck_ID)
