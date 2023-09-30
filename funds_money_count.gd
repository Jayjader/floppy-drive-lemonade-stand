extends Label

@export var money_in_cents:int:
	set(data):
		money_in_cents = data
		set_text("Funds: $%d.%02d" % [money_in_cents / 100, money_in_cents % 100])

@onready var viewport = get_viewport()

func __on_blank_floppies_purchased(count: int, cost: int):
	money_in_cents -= cost
