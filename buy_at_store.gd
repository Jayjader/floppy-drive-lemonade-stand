@tool
extends Button

signal blank_floppies_purchased(count: int, price_in_cents: int)

var choice: int:
	set(data):
		choice = data
		set_text("Buy for $%d.%2d" % [prices[choice] / 100, prices[choice] % 100])

@export var prices := {
	1: 15,
	25: 25 * 14,
	100: 100 * 13,
}

func _ready():
	choice = 1

func __on_purchase_volume_choice_made(volume: int):
	choice = volume

func __on_self_pressed():
	blank_floppies_purchased.emit(choice, prices[choice])
