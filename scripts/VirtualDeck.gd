extends Position2D

export(int) var base_z_index = 1

var associated_frame : TextureRect
var card_stack = []

func PushCard(var card : Position2D):
	card.assigned_vdeck = self
	card_stack.push_back(card)
	
	UpdateZIndices()

# Removes the top card from the deck and return its card ID.
# If get_obj is true, the card node is returned instead.
func PopCard(get_node : bool = false): 
	assert(card_stack.size() != 0)
	
	var popped_card = card_stack.pop_back()
	popped_card.assigned_vdeck = null
	UpdateZIndices()
	
	if (get_node):
		return popped_card
	else:
		return popped_card.name

# Removes a specific card from the vdeck.
func RemoveCard(var card):
	card_stack.remove(card_stack.find(card))
	UpdateZIndices()

# Assign z-indices so the bottom most card (index 0) has the lowest index. Last element
# should have a z-index of -1.
func UpdateZIndices():
	var current_size = card_stack.size()
	for i in current_size:
		card_stack[i].z_index = base_z_index + i
