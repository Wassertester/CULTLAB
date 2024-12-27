extends Node
@onready var volume: HSlider = $"../MarginContainer/VBoxContainer/Volume"
@onready var muted: CheckBox = $"../MarginContainer/VBoxContainer/CheckBox"
@onready var control_mode: OptionButton = $"../MarginContainer/VBoxContainer/OptionButton"
@onready var resolution: OptionButton = $"../MarginContainer/VBoxContainer/Resolution"
@onready var fullscreen_windowed: OptionButton = $"../MarginContainer/VBoxContainer/Fullscreen_windowed"
var save: settings_save
var ready_to_save = false

func _ready() -> void:
	if ResourceLoader.exists(settings_save.SAVE_PATH):
		save = load(settings_save.SAVE_PATH)
		load_()
	else:
		save = settings_save.new()

func save_():
	# this is importend bc signale sind instend und save() wird gecalled, wenn load() settings ändert
	if ready_to_save:
		save.settings = {"volume": volume.value, "muted": muted.button_pressed, "control_mode": control_mode.selected, "resolution": resolution.selected, "fullscreen_windowed": fullscreen_windowed.selected}
		save.save()
	
func load_():
	volume.value = save.settings["volume"]
	muted.button_pressed = save.settings["muted"]
	control_mode.selected = save.settings["control_mode"]
	resolution.selected = save.settings["resolution"]
	fullscreen_windowed.selected = save.settings["fullscreen_windowed"]
	ready_to_save = true

func _on_settings_setting_changed() -> void:
	save_()
