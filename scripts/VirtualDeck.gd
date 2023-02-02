extends Position2D

export(int) var base_z_index = 1

var associated_frame : TextureRect
var card_stack = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func PushCard(var card : Position2D):
	card.desired_position = position
	card_stack.push_back(card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
