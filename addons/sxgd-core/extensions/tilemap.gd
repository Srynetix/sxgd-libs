extends RefCounted
## [TileMap] extensions.
##
## Additional methods to work with [TileMap]s.

const SxLog = preload("res://addons/sxgd-core/extensions/logger.gd")

# Helper class representing transpose/flip parameters for a [TileMap] cell.
class CellRotationParams:
	extends Node

	## Cell is transposed.
	var transpose: bool
	## Cell is X flipped.
	var flip_x: bool
	## Cell is Y flipped.
	var flip_y: bool

	## Create rotation params instance from arguments.
	static func from_values(transpose: bool, flip_x: bool, flip_y: bool) -> CellRotationParams:
		var obj := CellRotationParams.new()
		obj.transpose = transpose
		obj.flip_x = flip_x
		obj.flip_y = flip_y
		return obj

## Get rotation for a specific cell, in radians.[br]
##
## Usage:
## [codeblock]
## var r := SxTileMap.get_cell_rotation(tilemap, pos)
## [/codeblock]
static func get_cell_rotation(tilemap: TileMap, pos: Vector2) -> float:
	var params := get_cell_rotation_params(tilemap, pos)
	return rotation_params_to_angle(params)

## Get rotation for a specific cell, in a custom class format.
static func get_cell_rotation_params(tilemap: TileMap, pos: Vector2) -> CellRotationParams:
	var x := int(pos.x)
	var y := int(pos.y)
	var data := tilemap.get_cell_tile_data(0, Vector2i(x, y))
	var transposed := data.transpose
	var flip_x := data.flip_h
	var flip_y := data.flip_v

	return CellRotationParams.from_values(transposed, flip_x, flip_y)

## Convert rotation params to an angle in radians.
static func rotation_params_to_angle(params: CellRotationParams) -> float:
	var logger := SxLog.get_logger("SxTileMap")

	if !params.transpose && !params.flip_x && !params.flip_y:
		return 0.0

	if params.transpose && !params.flip_x && params.flip_y:
		return -PI / 2

	if !params.transpose && params.flip_x:
		return PI

	if params.transpose && params.flip_x && !params.flip_y:
		return PI / 2

	logger.warn(
		"Unknown rotation for params (t: %s, fx: %s, fy: %s)"
		% [params.transpose, params.flip_x, params.flip_y]
	)

	return 0.0

## Generate cell rotation parameters from an angle in degrees.
static func rotation_degrees_to_params(angle_degrees: int) -> CellRotationParams:
	assert(angle_degrees in [0, 90, 180, 270], "Unsupported angle %d in 'rotation_degrees_to_params'" % angle_degrees)

	if angle_degrees == 90:
		return CellRotationParams.from_values(true, true, false)
	elif angle_degrees == 180:
		return CellRotationParams.from_values(false, true, true)
	elif angle_degrees == 270:
		return CellRotationParams.from_values(true, false, true)
	else:
		return CellRotationParams.from_values(false, false, false)

## Create a dump from tilemap contents.
static func create_dump(tilemap: TileMap) -> PackedInt32Array:
	return tilemap.get("tile_data")

## Overwrite tilemap contents with a dump.
static func apply_dump(tilemap: TileMap, array: PackedInt32Array) -> void:
	tilemap.clear()
	tilemap.set("tile_data", array)
