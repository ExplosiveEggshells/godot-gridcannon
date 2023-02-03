extends Position2D

export(int) var base_z_index = 1

var associated_frame : TextureRect
var card_stack = []
func _ready():
	pass # Replace with function body.

func PushCard(var card : Position2D):
	card.desired_position = position
	card_stack.push_back(card)
	
	# Assign z-indices so the bottom most card (index 0) has the lowest index. Last element
	# should have a z-index of -1.
	var current_size = card_stack.size()
	for i in current_size:
		card_stack[i].z_index = base_z_index + i
