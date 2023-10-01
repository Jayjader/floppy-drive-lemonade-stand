extends Label

@export var funds_stock: Label

func __on_rent_payment_attempted(success: bool):
	if not success:
		var funds = funds_stock.money_in_cents
		var x = "%d.%02d" % [roundi(funds / 100), funds % 100]
		var rent = funds_stock.MONTHLY_DORM_RENT
		var y = "%d.%02d" % [roundi(rent / 100), rent % 100]
		var lacking = funds - rent
		var z = "%d.%02d" % [roundi(lacking / 100), lacking % 100]
		set_text("You weren't able to pay rent for this month :(\n%s - %s = %s" % [x, y, z])
