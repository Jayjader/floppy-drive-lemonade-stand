extends Label

signal blank_stock_changed(new_count: int)

@export var count: int = 0:
	set(data):
		if count != data:
			emit_signal.call_deferred("blank_stock_changed", data) # deferred so that the rest of the scene has loaded and can receive the initial signal
		count = data
		set_text("x %s" % count)


func __on_blank_floppies_purchased(amount: int, _price_in_cents):
	count += amount


func __on_floppy_drives_written(amount: int, _loadout):
	count -= amount


func __on_written_drives_erased(amount: int):
	count += amount
