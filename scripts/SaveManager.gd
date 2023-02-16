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
	var i = 0
	for deck in gm.deck_dict.values():
		i += 1
		save_deck(save_file, deck)
	
	print(i)
	save_file.close()
	
	return OK

func save_deck(file : File, deck):
	file.store_pascal_string(deck.associated_frame.deck_name)
	file.store_8(deck.card_stack.size())
	for card in deck.card_stack:
		save_card(file, card)

func save_card(file : File, card):
	var id = ((card.suit - 1) * 13) + card.value
	
	var suit = int((id-1) / 13) + 1
	var value = id - (int((id-1) / 13) * 13)
	if (value == 14):
		value = 1
		
	var string_id = str(suit) + "_" + str(value)
	
	if (string_id != card.name):
		print(card.name + " -> " + str(id) + " -> " + str(suit) + "_" + str(value))
	
	file.store_8(id)
	file.store_8(card.alive)

func load_game():
	if (gm.card_dict == null || gm.card_dict.empty()):
		return SaveCode.NOT_READY
		
	var load_file = File.new()
	var rc = load_file.open(SAVE_GAME, File.READ)
	if (rc != OK):
		push_error("Load failed to open " + SAVE_GAME + ". Return code " + rc)
		return SaveCode.BAD_ACCESS
	
	var loaded_game : GameSaveData
	loaded_game = GameSaveData.new()
	
	loaded_game.save_format = load_file.get_8()
	loaded_game.game_state = load_file.get_pascal_string()
	
	for i in gm.deck_dict.size():
		loaded_game.decks.append(load_deck(load_file))
	
	load_file.close()
	
	return loaded_game
	

func load_deck(load_file : File) -> DeckSaveData:
	var deck_name = load_file.get_pascal_string()
	var deck_size = load_file.get_8()
	
	var cards_data = []
	for i in deck_size:
		cards_data.append(load_card(load_file))
	
	return DeckSaveData.new(deck_name, cards_data)

func load_card(load_file : File) -> CardSaveData:
	var numeric_id = load_file.get_8()
	var suit = int((numeric_id - 1) / 13) + 1
	var value = numeric_id - (int((numeric_id - 1) / 13) * 13)
	
	if (value == 14):
		value = 1
	
	var string_id = str(suit) + "_" + str(value)
	
	var alive = load_file.get_8()
	
	return CardSaveData.new(string_id, alive)
