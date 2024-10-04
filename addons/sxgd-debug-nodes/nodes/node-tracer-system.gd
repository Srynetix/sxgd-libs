extends MarginContainer
## Node tracer system.
##
## Allow to display custom updated information for specific nodes in the
## [SxDebugTools].
## To use with [SxNodeTracer]s.

const SxLog := preload("res://addons/sxgd-core/extensions/logger.gd")
const SxNodeTracer := preload("res://addons/sxgd-debug-nodes/nodes/node-tracer.gd")
const SxNodeTracerPanel := preload("res://addons/sxgd-debug-nodes/nodes/node-tracer-panel.gd")

var _tracers := {}
var _tracers_ui := {}
var _logger := SxLog.get_logger("SxNodeTracerSystem")

var _grid: GridContainer

func _ready() -> void:
	name = "SxNodeTracerSystem"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var vbox_container := VBoxContainer.new()
	vbox_container.add_theme_constant_override("separation", 0)
	add_child(vbox_container)

	var margin_container := MarginContainer.new()
	vbox_container.add_child(margin_container)

	var margin_container2 := MarginContainer.new()
	margin_container2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin_container2.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin_container2.add_theme_constant_override("margin_right", 5)
	margin_container2.add_theme_constant_override("margin_top", 5)
	margin_container2.add_theme_constant_override("margin_left", 5)
	margin_container2.add_theme_constant_override("margin_bottom", 5)
	vbox_container.add_child(margin_container2)

	_grid = GridContainer.new()
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_grid.columns = 2
	margin_container2.add_child(_grid)

func _process(delta: float) -> void:
	for node in get_tree().get_nodes_in_group("SxNodeTracer"):
		var tracer := node as SxNodeTracer
		var node_path := str(tracer.get_path())

		if !_tracers.has(node_path):
			_logger.debug_m("_process", "Registering SxNodeTracer '%s'." % tracer.title)
			_tracers[node_path] = node
			var ui := _create_tracer_ui(node_path, node)
			node.tree_exiting.connect(_remove_tracer_ui.bind(node_path, ui))
		else:
			_update_tracer_ui(node, _tracers_ui[node_path])

func _create_tracer_ui(path: String, tracer: SxNodeTracer) -> SxNodeTracerPanel:
	var ui = SxNodeTracerPanel.new()
	_tracers_ui[path] = ui
	_grid.add_child(ui)
	_update_tracer_ui(tracer, ui)
	return ui

func _update_tracer_ui(tracer: SxNodeTracer, ui: SxNodeTracerPanel) -> void:
	ui.update_using_tracer(tracer)

func _remove_tracer_ui(path: String, ui: SxNodeTracerPanel) -> void:
	_tracers.erase(path)
	_tracers_ui.erase(path)
	_grid.remove_child(ui)
	ui.queue_free()
