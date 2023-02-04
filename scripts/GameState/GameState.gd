# StateMachine framework as written by Nathan Lovato of GDQuest.com
# CC-By 4.0 www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

class_name GameState
extends Node

var sm = null	# Parent State Machine

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_parms := {}) -> void:
	pass

func exit() -> void:
	pass
