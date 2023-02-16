extends TextureButton

func _ready():
	connect("button_down", GameManager, "load_save")
