extends MarginContainer

@onready var world := %SxVerletWorld as SxVerletPhysics.VerletWorld

func _ready() -> void:
	var _point_configurator = func(point: SxVerletPhysics.VerletPoint):
		point.radius = 15

	var _link_configurator = func(link: SxVerletPhysics.VerletLink):
		link.tear_sensitivity = 100.0
		link.stiffness = 0.1

	world.add_behavior(SxVerletPhysics.GravityBehavior.new())
	world.create_chain().add_point_at_position(Vector2(100, 100)).add_point_chain_with_same_offset(4, Vector2(50, 50)).build()
	world.create_cloth(Vector2(200, 150), Vector2(8, 8), 50, SxVerletPhysics.VerletCloth.PinMode.Top, _point_configurator, _link_configurator)
