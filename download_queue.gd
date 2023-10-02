extends VBoxContainer

@export var downloads: Array[DownloadRs] = []
@export var local_files: Tree

@onready var grid: GridContainer = $GridContainer

func add_download(d: DownloadRs):
	downloads.append(d)
	var label = Label.new()
	label.set_text(d.file.name)
	grid.add_child(label)
	var progress = ProgressBar.new()
	progress.min_value = 0
	progress.max_value = d.file.size
	progress.value = 0
	progress.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(progress)
	var cancel = Button.new()
	cancel.set_text("Cancel")
	cancel.pressed.connect(__on_download_cancelled.bind(d, label, progress, cancel), CONNECT_ONE_SHOT)
	grid.add_child(cancel)
	
	d.bytes_downloaded.connect(func(_bytes, total): progress.value = total)
	d.download_finished.connect(func(_file): for c in d.bytes_downloaded.get_connections(): d.bytes_downloaded.disconnect(c.callable))
	d.download_finished.connect(local_files.__on_file_downloaded, CONNECT_ONE_SHOT)
	d.download_finished.connect(__on_download_finished.bind(d, label, progress, cancel), CONNECT_ONE_SHOT)

const BYTES_PER_HOUR = 56 * 2**10 * 3600 # 56KiB/s

func _ready():
	(func():
		var test_file1 = FileRs.new()
		test_file1.name = "office_CRACKED_xxx1337hak0r5xxx.exe"
		test_file1.size = 9724*(2**14)
		
		var test_file2 = FileRs.new()
		test_file2.name = "bar.txt"
		test_file2.size = 11*(2**8)
		
		var test_file3 = FileRs.new()
		test_file3.name = "warez.exe"
		test_file3.size = 32*(2**12)
		
		var test_file4 = FileRs.new()
		test_file4.name = "foo.txt"
		test_file4.size = 33*(2**10)
		
		var d1 = DownloadRs.new()
		d1.file = test_file1
		add_download(d1)
		var d2 = DownloadRs.new()
		d2.file = test_file2
		add_download(d2)
		var d3 = DownloadRs.new()
		d3.file = test_file3
		add_download(d3)
		var d4 = DownloadRs.new()
		d4.file = test_file4
		add_download(d4)
	).call_deferred()

func __on_download_cancelled(download: DownloadRs, label: Label, progress: ProgressBar, cancel: Button):
	local_files.free_download_space(download.progress)
	downloads.erase(download)
	label.queue_free()
	progress.queue_free()
	cancel.queue_free()

func __on_download_finished(_file, download: DownloadRs, label: Label, progress: ProgressBar, cancel: Button):
	downloads.erase(download)
	label.queue_free()
	progress.queue_free()
	cancel.queue_free()

func __on_time_hour_advanced():
	var bandwidth_quota = BYTES_PER_HOUR
	for download in downloads:
		var remaining = download.get_remaining()
		var to_reserve_locally = min(remaining, bandwidth_quota)
		var reserved = local_files.reserve_for_download(to_reserve_locally)
		if reserved == 0:
			break
		bandwidth_quota -= reserved
		download.download_bytes(reserved)
		if reserved < to_reserve_locally:
			break
		if bandwidth_quota == 0:
			break


func __on_in_class_state_entered():
	# 8:00 -> 18:00
	for t in range(10):
		__on_time_hour_advanced()


func __on_sleeping_state_entered():
	# 18:00 -> 8:00
	for t in range(14):
		__on_time_hour_advanced()


func __on_torrent_enqueued(torrent: TorrentRs):
	var download = DownloadRs.new()
	download.file = torrent.file
	add_download(download)
