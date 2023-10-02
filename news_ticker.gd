extends VBoxContainer


@export var created_torrents: Array[TorrentRs]
@export var to_be_created_torrents: Array[TorrentRs]

var _random := RandomNumberGenerator.new()


const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

func _generate_message(templates: Array[MessageTemplateRs]):
	var t = templates.pick_random()
	if t != null:
		var author = t.authors.pick_random()
		var message = t.texts.pick_random()
		var message_container = VBoxContainer.new()
		message_container.size_flags_horizontal = Control.SIZE_FILL
		var author_label = Label.new()
		author_label.text = author
		var message_content = Label.new()
		message_content.text = message
		message_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		message_content.size_flags_horizontal = Control.SIZE_FILL
		message_container.add_child(author_label)
		message_container.add_child(HSeparator.new())
		message_container.add_child(message_content)
		
		var sep_bot = HSeparator.new()
		add_child(sep_bot)
		move_child(sep_bot, 0)
		add_child(message_container)
		move_child(message_container, 0)
		var sep_top = HSeparator.new()
		add_child(sep_top)
		move_child(sep_top, 0)

func _insert_timestamp(hours: int, day: int, month: String):
		var sep_bot = HSeparator.new()
		add_child(sep_bot)
		move_child(sep_bot, 0)
		var timestamp = Label.new()
		if hours >= 24:
			day += 1
			if day > 30:
				day -= 30
				month = MONTHS[(MONTHS.find(month)+1)%12]
			hours -= 24
		timestamp.text = "%2d %s - %02d:00" % [day, month, hours]
		add_child(timestamp)
		move_child(timestamp, 0)
		var sep_top = HSeparator.new()
		add_child(sep_top)
		move_child(sep_top, 0)

func __on_torrent_created(torrent: TorrentRs):
	print_debug("torrent created: %s" % torrent)
	to_be_created_torrents.erase(torrent)
	created_torrents.append(torrent)

var _day = 1
var _month = "September"
func __on_today_date_changed(day, month):
	_day = day
	_month = month

var first_day_started = false
func __on_time_of_day_changed(new_time):
	print_debug("time of day changed to %s" % ("morning" if new_time == 0 else "evening"))
	if not first_day_started:
		first_day_started = true
		return
	var start = 8 if new_time == 1 else 18
	var hours_passed = 10 if new_time == 1 else 14
	var day = _day if new_time == 1 else (_day - 1)
	var month = _month
	for hour in range(start, start+hours_passed):
		var posted = false
		for c_t in created_torrents:
			if _random.randf() > 0.75 and len(c_t.messages_after_creation) > 0:
				posted = true
				_generate_message(c_t.messages_after_creation)
		for t_b_c in to_be_created_torrents:
			if _random.randf() > 0.85 and len(t_b_c.messages_before_creation) > 0:
				posted = true
				_generate_message(t_b_c.messages_before_creation)
		if posted:
			_insert_timestamp(hour, day, month)


