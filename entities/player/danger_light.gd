extends OmniLight

const red = Color(1, 0, 0)
const disabled = Color(0, 0, 0)

export var enabled = false

func _process(delta):
	if !enabled:
		light_color = disabled
		return
	if OS.get_ticks_msec() / 50 % 10 < 5:
		light_color = red
	else:
		light_color = disabled
