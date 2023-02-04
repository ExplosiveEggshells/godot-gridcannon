extends TextureButton

export(String) var deck_name
export(bool) var face_up_deck = true	# Should cards in this deck be face up when added?
export(bool) var auto_register = false	# Should this deck add itself to the deck dictionary on ready?
export(Vector2) var default_size

var virtual_deck

func _ready():
	connect("button_down", self, "ScaleReport")
	virtual_deck = $VirtualDeck
	
	$RepivotTimer.connect("timeout", self, "UpdatePivot")
	connect("button_down", self, "TestControl")
	
	$RepivotTimer.start()
	virtual_deck.associated_frame = self
	
	if (auto_register):
		GameManager.deck_dict[deck_name] = virtual_deck

func UpdatePivot():
	var pivot_x = rect_size.x / 2
	var pivot_y = rect_size.y / 2
	rect_pivot_offset = Vector2(pivot_x, pivot_y)
	virtual_deck.position = Vector2(pivot_x, pivot_y)
	
	# Change the scale of the virtual deck to match the UI Scaling of the deck frame.
	# Cards in the vdeck will read its scale and adjust themselves accordingly.
	var resized_scale = Vector2(rect_size.x / default_size.x, rect_size.y / default_size.y)
	virtual_deck.global_scale = resized_scale

func ScaleReport():
	print(str(virtual_deck.global_scale))
