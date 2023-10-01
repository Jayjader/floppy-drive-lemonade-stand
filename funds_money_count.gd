extends Label

signal rent_payment_attempted(success: bool)

const MONTHLY_DORM_RENT = 5000

@export var money_in_cents:int:
	set(data):
		money_in_cents = data
		set_text("Funds: $%d.%02d" % [money_in_cents / 100, money_in_cents % 100])

@onready var viewport = get_viewport()

func __on_blank_floppies_purchased(_count: int, cost: int):
	money_in_cents -= cost


func __on_today_date_rent_needed():
	var success = money_in_cents > MONTHLY_DORM_RENT
	if success:
		money_in_cents -= MONTHLY_DORM_RENT
	rent_payment_attempted.emit(success)


func __on_written_drives_sold(sales: Array[int]):
	money_in_cents += sales.reduce(func(a,b): return a+b, 0)
