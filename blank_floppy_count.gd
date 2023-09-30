extends Label

@export var count: int = 0:
	set(data):
		count = data
		set_text("x %s" % count)


func __on_blank_floppies_purchased(amount: int, price_in_cents: int):
	count -= amount
