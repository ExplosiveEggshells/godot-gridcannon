extends TextureRect

func _ready():
	$RepivotTimer.connect("timeout", self, "UpdatePivot")
	$RepivotTimer.start()

func UpdatePivot():
	var pivot_x = rect_size.x / 2
	var pivot_y = rect_size.y / 2
	rect_pivot_offset = Vector2(pivot_x, pivot_y)
