extends GameState

func update(_delta: float) -> void:
	if (check_essential_references()):
		sm.transition_to("Setup")

func check_essential_references() -> bool:
	if (sm.deck_container == null):
		return false
	if (sm.game_root == null):
		return false
	return true
