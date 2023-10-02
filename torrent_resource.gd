class_name TorrentRs
extends Resource

@export var file: FileRs
@export var creation_day: int
@export var creation_month: StringName
@export var tags: Array[StringName]

@export var messages_before_creation: Array[MessageTemplateRs]
@export var messages_after_creation: Array[MessageTemplateRs]

const DOCUMENT = &"DOCUMENT"
const SOFTWARE = &"SOFTWARE"
const TEXT = &"TEXT"
const PDF = &"PDF"
const IMAGE = &"IMAGE"
const AUDIO = &"AUDIO"
const VIDEO = &"VIDEO"
const TOOL = &"TOOL"
const GAME = &"GAME"
