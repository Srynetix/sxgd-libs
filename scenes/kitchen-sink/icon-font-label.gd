extends Control

@onready var custom_icon_text := %CustomEdit as LineEdit
@onready var custom_icon_value := %CustomIcon as SxIconFont.IconLabel
@onready var custom_size := %CustomSize as SpinBox
@onready var custom_color := %CustomColor as ColorPickerButton

func _ready() -> void:
	custom_icon_text.text_changed.connect(func(value):
		custom_icon_value.icon_name = value
	)

	custom_color.color_changed.connect(func(value):
		custom_icon_value.icon_color = value
	)

	custom_size.value_changed.connect(func(value):
		custom_icon_value.icon_size = value
	)
