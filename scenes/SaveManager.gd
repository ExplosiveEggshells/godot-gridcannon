extends Node

enum SaveCode {OK, NOT_READY, BAD_ACCESS, SAVE_FAIL, LOAD_FAIL}

export(int) var save_format = 0		# ID used to identify save formats, in case conversions are needed.

const SAVE_GAME = "user://game.dat"

var gm

func _ready():
	gm = get_node("/root/GameManager")

func save_game():
	
	if (gm.card_dict == null || gm.card_dict.empty()):
		return SaveCode.NOT_READY
	
	var save_file = File.new()
	var rc = save_file.open(SAVE_GAME, File.WRITE)
	if (rc != OK):
		push_error("Save failed to open " + SAVE_GAME + ". Return code " + rc)
		return SaveCode.BAD_ACCESS
	
	save_file.store_8(save_format)		# Store the current save format
	save_file.store_pascal_string(GameManager.state.name)
	
	for card in gm.card_dict.values():
		save_card(save_file, card)
	
	save_file.close()
	
	return OK

func save_card(file : File, card):
	var has_vdeck = 1 if card.assigned_vdeck != null else 0
	file.store_8(has_vdeck)
	if (has_vdeck == 1):
		file.store_pascal_string(card.assigned_vdeck.associated_frame.deck_name)
		
	file.store_8(card.alive)

func load_game():
	if (gm.card_dict == null || gm.card_dict.empty()):
		return SaveCode.NOT_READY
	pass
	
func load_card():
	pass
