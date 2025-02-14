extends HSlider

export var AudioBusName := "Master"

onready var _bus := AudioServer.get_bus_index(AudioBusName)

func _ready() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(_bus))
	
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))


func _on_VolumeSlider_value_changed(value):
	_on_value_changed(value)


func _on_VolumeSlider_mouse_exited():
	release_focus()
