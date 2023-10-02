extends VBoxContainer


@export var created_torrents: Array[TorrentRs]
@export var to_be_created_torrents: Array[TorrentRs]

var _random := RandomNumberGenerator.new()

func _generate_message(templates: Array[MessageTemplateRs]):
	for t in templates:
		var author = t.authors.pick_random()
		var message = t.texts.pick_random()
		var message_container = VBoxContainer.new()
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

func __on_torrent_created(torrent: TorrentRs):
	print_debug("torrent created: %s" % torrent)
	to_be_created_torrents.erase(torrent)
	created_torrents.append(torrent)

func __on_time_of_day_changed(new_time):
	print_debug("time of day changed to %s" % ("morning" if new_time == 0 else "evening"))
	var hours_passed = 14 if new_time == 0 else 10
	for h in range(hours_passed):
		for c_t in created_torrents:
			if _random.randf() > 0.9:
				print_debug("generate for created")
				_generate_message(c_t.messages_after_creation)
		for t_b_c in to_be_created_torrents:
			if _random.randf() > 0.9:
				print_debug("generate for upcoming")
				_generate_message(t_b_c.messages_before_creation)
