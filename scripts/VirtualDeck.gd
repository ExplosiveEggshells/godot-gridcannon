extends Position2D

export(int) var base_z_index = 1

var drawable = false		# Can a card be moved from this deck by the player?
var receptible = false		# Can a card be moved onto this deck by the player?

var grid_x = -1
var grid_y = -1

var associated_frame : TextureButton
var animation_player : AnimationPlayer
var card_stack = []
var deck_type

var face_up = true

func _ready():
	associated_frame = get_parent()
	animation_player = get_parent().get_node("AnimationPlayer")
	assert(animation_player != null)

func PushCard(var card : Position2D):
	card.assigned_vdeck = self
	card_stack.push_back(card)
	
	card.set_face_up(face_up)
	
	UpdateZIndices()

# Removes the top card from the deck and return its card ID.
# If get_obj is true, the card node is returned instead.
func PopCard(get_node : bool = false): 
	assert(card_stack.size() != 0)
	
	var popped_card = card_stack.pop_back()
	popped_card.assigned_vdeck = null
	popped_card.z_index = base_z_index + 1
	UpdateZIndices()
	
	if (get_node):
		return popped_card
	else:
		return popped_card.name

func top_card() -> Position2D:
	if (!card_stack.empty()):
		return card_stack.back()
	return null

# Removes a specific card from the vdeck.
func RemoveCard(var card):
	card_stack.remove(card_stack.find(card))
	card.assigned_vdeck = null
	card.z_index = base_z_index + 1
	
	UpdateZIndices()

# Assign z-indices so the bottom most card (index 0) has the lowest index. Last element
# should have a z-index of -1.
func UpdateZIndices():
	var current_size = card_stack.size()
	for i in current_size:
		card_stack[i].z_index = -current_size + i + base_z_index

func shuffle() -> void:
	var current_size = card_stack.size()
	for i in (current_size - 1):
		var swap_pos = GameManager.rng.randi_range(0, current_size - 1)
		var swap_card = card_stack[swap_pos]
		
		card_stack[swap_pos] = card_stack[i]
		card_stack[i] = swap_card
	
	UpdateZIndices()

func set_receptible(state : bool) -> void:
	receptible = state
	update_animation_state()
	
func set_drawable(state: bool) -> void:
	drawable = state
	update_animation_state()

func update_animation_state() -> void:
	if (drawable):
		animation_player.play("drawable")
	elif (receptible):
		animation_player.play("receptible")
	else:
		animation_player.play("RESET")

func on_deck_pressed() -> void:
	if (drawable):
		if (card_stack.empty()):
			return
		card_stack[-1].follow_mouse = true
