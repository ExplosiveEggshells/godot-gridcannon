extends MarginContainer

var cards = []

func _ready():
	pass

func AddCard(var card):
	cards.push_front(card)
