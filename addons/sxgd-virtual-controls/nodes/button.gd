@tool
extends TextureRect
## Virtual button, to use with the [SxVirtualControls].

const BACKGROUND = preload("res://addons/sxgd-virtual-controls/assets/textures/transparentDark/transparentDark09.png")

const INITIAL_OPACITY := 0.5
const TOUCHED_OPACITY := 1.0

## On button touch.
signal touched()
## On button release.
signal released()

## Action button.
@export var action_button: String

var _button_touch_index := -1

func _init() -> void:
	if custom_minimum_size == Vector2.ZERO:
		custom_minimum_size = Vector2(64, 64)
	if !size_flags_horizontal:
		size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	if !size_flags_vertical:
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if !texture:
		texture = BACKGROUND

	expand_mode = TextureRect.EXPAND_IGNORE_SIZE

func _color_with_alpha(color: Color, alpha: float) -> Color:
	var c := color
	c.a = alpha
	return c

func _ready() -> void:
	modulate = _color_with_alpha(Color.WHITE, INITIAL_OPACITY)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if !touch_event.pressed && touch_event.index == _button_touch_index:
			_button_touch_index = -1
			modulate = _color_with_alpha(Color.WHITE, INITIAL_OPACITY)
			_send_button_event(false)
			emit_signal("released")
		elif _button_touch_index == -1 && touch_event.pressed && get_global_rect().has_point(touch_event.position):
			_button_touch_index = touch_event.index
			modulate = _color_with_alpha(Color.WHITE, TOUCHED_OPACITY)
			_send_button_event(true)
			emit_signal("touched")

func _send_button_event(pressed: bool):
	if action_button != "":
		if pressed:
			Input.action_press(action_button)
		else:
			Input.action_release(action_button)
