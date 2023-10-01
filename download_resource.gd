class_name DownloadRs
extends Node

signal bytes_downloaded(new: int, total: int)
signal finished(file: FileRs)

enum DownloadState {
	Queued,
	InProgress,
	Finished
}

@export var file: FileRs
@export var state: DownloadState = DownloadState.Queued

var progress = 0

func _start_download():
	state = DownloadState.InProgress

func download_bytes(bytes: int):
	if state == DownloadState.Queued:
		_start_download()
	progress += bytes
	bytes_downloaded.emit(bytes, progress)
	if progress >= file.size:
		progress = file.size
		state = DownloadState.Finished
		finished.emit(file)

func get_remaining() -> int:
	return file.size - progress
