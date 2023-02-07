extends GameState

func update(_delta: float) -> void:
	if (check_essential_references()):
		GameManager.main_deck = GameManager.deck_dict["main_deck"]
		GameManager.transition_to("Setup")

func check_essential_references() -> bool:
	if (GameManager.deck_container == null):
		return false
	if (GameManager.game_root == null):
		return false
	return true
