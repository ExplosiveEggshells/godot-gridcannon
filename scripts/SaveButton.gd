extends TextureButton

func _ready():
	connect("button_down", self, "_on_button_down")
	
func _on_button_down():
	print("button pressed")
	var rc = SaveManager.save_game()
	print("Save returned " + str(rc))
