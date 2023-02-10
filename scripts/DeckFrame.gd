extends TextureButton

export(String) var deck_name
export(int) var initial_deck_type = 0
export(bool) var face_up_deck = true	# Should cards in this deck be face up when added?
export(bool) var auto_register = false	# Should this deck add itself to the deck dictionary on ready?
export(Vector2) var default_size

var virtual_deck

func _ready():
	virtual_deck = $VirtualDeck
	
	
	connect("button_down", virtual_deck, "on_deck_pressed")
	$RepivotTimer.connect("timeout", self, "UpdatePivot")
	$RepivotTimer.start()
	
	virtual_deck.associated_frame = self
	virtual_deck.face_up = face_up_deck
	
	if (auto_register):
		GameManager.deck_dict[deck_name] = virtual_deck
	
	assign_deck_type()

func UpdatePivot():
	var new_pivot = Vector2(rect_size.x / 2, rect_size.y / 2)
	rect_pivot_offset = new_pivot
	virtual_deck.position = new_pivot
	
	$DropArea.position = new_pivot
	
	# Change the scale of the virtual deck to match the UI Scaling of the deck frame.
	# Cards in the vdeck will read its scale and adjust themselves accordingly.
	var resized_scale = Vector2(rect_size.x / default_size.x, rect_size.y / default_size.y)
	virtual_deck.scale = resized_scale

func assign_deck_type() -> void:
	match initial_deck_type:
		1:
			virtual_deck.deck_type = DeckType.GRID_NUMBER
		2: 
			virtual_deck.deck_type = DeckType.GRID_ROYAL
		3:
			virtual_deck.deck_type = DeckType.PLOY
		4:
			virtual_deck.deck_type = DeckType.STOCK
