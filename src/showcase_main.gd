extends Node3D
## Nocturne Atrium: a compact real-time environment built from Godot primitives.
## The scene is intentionally asset-light so every visual result is reproducible.

const ACCENT_CYAN := Color("57e6ff")
const ACCENT_AMBER := Color("ffb454")
const DEEP_BLUE := Color("0b1830")
const PANEL_BLUE := Color("122643")

var player: Node3D
var camera: Camera3D
var fps_label: Label
var status_label: Label
var prompt_label: Label
var capture_mode := ""
var capture_timer := 0.0
var interactable_nodes: Array[Node3D] = []
var interactable_names: Array[String] = []
var interactable_active: Array[bool] = []
var interactable_materials: Array[StandardMaterial3D] = []
var beacon_orbit := 0.0

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture="):
			capture_mode = argument.get_slice("=", 1)
	_build_environment()
	_build_architecture()
	_build_lighting()
	_build_player()
	_build_interface()
	_apply_capture_preset()

func _process(delta: float) -> void:
	_update_camera(delta)
	_update_interactions(delta)
	_update_interface()
	if capture_mode != "":
		capture_timer += delta
		if capture_timer > 1.4:
			_capture_screenshot(capture_mode)
			get_tree().quit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(-event.relative.x * 0.0025)
		camera.rotation.x = clamp(camera.rotation.x - event.relative.y * 0.0025, -1.15, 1.15)
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			_toggle_nearest()
		elif event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _build_environment() -> void:
	var world := WorldEnvironment.new()
	world.name = "WorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("071225")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("496a9b")
	environment.ambient_light_energy = 0.72
	environment.reflected_light_source = Environment.REFLECTION_SOURCE_BG
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.tonemap_exposure = 1.15
	environment.glow_enabled = true
	environment.glow_intensity = 0.85
	environment.glow_strength = 1.15
	world.environment = environment
	add_child(world)

func _build_lighting() -> void:
	var key_light := DirectionalLight3D.new()
	key_light.name = "DirectionalKeyLight"
	key_light.light_color = Color("b7d1ff")
	key_light.light_energy = 1.15
	key_light.rotation_degrees = Vector3(-52.0, -32.0, 0.0)
	key_light.shadow_enabled = true
	key_light.directional_shadow_max_distance = 70.0
	add_child(key_light)

	var cyan_fill := OmniLight3D.new()
	cyan_fill.name = "OmniCyanFill"
	cyan_fill.light_color = ACCENT_CYAN
	cyan_fill.light_energy = 2.2
	cyan_fill.omni_range = 12.0
	cyan_fill.shadow_enabled = true
	cyan_fill.position = Vector3(-4.5, 3.2, 0.5)
	add_child(cyan_fill)

	var amber_spot := SpotLight3D.new()
	amber_spot.name = "SpotAmberKey"
	amber_spot.light_color = ACCENT_AMBER
	amber_spot.light_energy = 4.2
	amber_spot.spot_range = 17.0
	amber_spot.spot_angle = 34.0
	amber_spot.shadow_enabled = true
	amber_spot.position = Vector3(4.0, 6.5, 3.0)
	amber_spot.rotation_degrees = Vector3(-48.0, 35.0, 0.0)
	add_child(amber_spot)

func _build_architecture() -> void:
	var floor_material := _material(Color("152744"), 0.76, 0.12)
	var trim_material := _material(Color("253b60"), 0.48, 0.32)
	var cyan_material := _material(ACCENT_CYAN.darkened(0.22), 0.27, 0.65, ACCENT_CYAN)
	var amber_material := _material(ACCENT_AMBER.darkened(0.3), 0.34, 0.48, ACCENT_AMBER)
	var white_material := _material(Color("d9e8ff"), 0.3, 0.08)
	cyan_material.normal_enabled = true
	cyan_material.normal_texture = _make_normal_texture()
	cyan_material.normal_scale = 0.35

	_add_static_box("AtriumFloor", Vector3(0, -0.18, 0), Vector3(18, 0.35, 14), floor_material)
	_add_static_box("BackWall", Vector3(0, 3.2, -6.6), Vector3(18, 6.8, 0.3), trim_material)
	_add_static_box("LeftWall", Vector3(-8.6, 3.2, 0), Vector3(0.3, 6.8, 14), trim_material)
	_add_static_box("RightWall", Vector3(8.6, 3.2, 0), Vector3(0.3, 6.8, 14), trim_material)

	# Framed ceiling beams create a readable vertical rhythm without imported meshes.
	for x in [-7.0, -3.5, 0.0, 3.5, 7.0]:
		_add_static_box("CeilingBeam_%s" % str(x), Vector3(x, 6.5, -0.3), Vector3(0.28, 0.28, 12.5), trim_material)
	for z in [-5.0, -1.5, 2.0, 5.2]:
		_add_static_box("FloorInset_%s" % str(z), Vector3(0, 0.03, z), Vector3(15.0, 0.06, 0.08), cyan_material)

	# Central display plinth and floating beacon.
	_add_static_box("CentralPlinth", Vector3(0, 0.75, -0.5), Vector3(3.3, 1.5, 2.5), trim_material)
	_add_box("PlinthTop", Vector3(0, 1.54, -0.5), Vector3(2.8, 0.10, 2.0), white_material, self)
	var beacon := _add_sphere("LumenBeacon", Vector3(0, 3.15, -0.5), 0.72, cyan_material, self)
	_register_interactable(beacon, "Lumen Beacon", cyan_material)
	_add_torus("BeaconRing", Vector3(0, 3.15, -0.5), 1.28, 0.06, amber_material)
	_add_torus("BeaconRing_Upper", Vector3(0, 3.15, -0.5), 0.96, 0.035, cyan_material)

	# Two approach pylons make the interaction readable in the composition.
	var pylon_material := _material(Color("243653"), 0.42, 0.38)
	for index in range(2):
		var x := -5.0 if index == 0 else 5.0
		var pylon := _add_cylinder("Pylon_%d" % index, Vector3(x, 1.25, 1.2), 0.62, 2.5, pylon_material, self)
		_add_cylinder("PylonCap_%d" % index, Vector3(x, 2.58, 1.2), 0.32, 0.18, amber_material, self)
		_register_interactable(pylon, "North Pylon" if index == 0 else "South Pylon", amber_material)

	# Side columns and planters provide scale cues and contact shadows.
	for index in range(4):
		var x := -6.9 + float(index % 2) * 13.8
		var z := -4.3 + float(index / 2) * 8.1
		_add_static_box("Column_%d" % index, Vector3(x, 2.3, z), Vector3(0.62, 4.6, 0.62), trim_material)
		_add_cylinder("ColumnCap_%d" % index, Vector3(x, 4.72, z), 0.82, 0.18, white_material, self)
		_add_static_box("Planter_%d" % index, Vector3(x * 0.72, 0.34, z * 0.74), Vector3(1.4, 0.7, 1.4), pylon_material)
		_add_sphere("PlanterGlow_%d" % index, Vector3(x * 0.72, 1.0, z * 0.74), 0.34, cyan_material, self)

func _build_player() -> void:
	player = Node3D.new()
	player.name = "FreeCameraRig"
	player.position = Vector3(0.0, 0.0, 7.8)
	add_child(player)
	camera = Camera3D.new()
	camera.name = "ShowcaseCamera"
	camera.position = Vector3(0.0, 4.5, 10.8)
	camera.fov = 55.0
	camera.current = true
	player.add_child(camera)
	camera.look_at(Vector3(0.0, 2.0, -0.8))

func _build_interface() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "PortfolioHUD"
	add_child(canvas)
	var top_bar := ColorRect.new()
	top_bar.color = Color(0.025, 0.06, 0.12, 0.92)
	top_bar.position = Vector2(0, 0)
	top_bar.size = Vector2(1280, 84)
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(top_bar)
	var title := _label(canvas, "NOCTURNE ATRIUM", Vector2(42, 17), Vector2(580, 32), 26, Color("f1f6ff"))
	title.add_theme_constant_override("outline_size", 8)
	title.add_theme_color_override("font_outline_color", Color(0.02, 0.04, 0.08, 0.9))
	_label(canvas, "REAL-TIME 3D ENVIRONMENT SHOWCASE  /  GODOT 4.7", Vector2(44, 50), Vector2(640, 20), 11, Color("80a5d2"))
	var chip := ColorRect.new()
	chip.color = Color(0.12, 0.45, 0.55, 0.35)
	chip.position = Vector2(1056, 24)
	chip.size = Vector2(176, 34)
	chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(chip)
	_label(canvas, "PROCEDURAL ASSET PIPELINE", Vector2(1071, 33), Vector2(150, 18), 10, ACCENT_CYAN)

	var info_card := ColorRect.new()
	info_card.color = Color(0.025, 0.055, 0.11, 0.88)
	info_card.position = Vector2(34, 558)
	info_card.size = Vector2(380, 128)
	info_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(info_card)
	_label(canvas, "INTERACTION LAYER", Vector2(56, 578), Vector2(280, 20), 11, ACCENT_AMBER)
	prompt_label = _label(canvas, "[E]  Activate the nearest beacon or pylon", Vector2(56, 606), Vector2(330, 24), 15, Color("e9f1ff"))
	_label(canvas, "WASD / ARROWS  Move camera     Mouse  Look     ESC  Release cursor", Vector2(56, 646), Vector2(335, 34), 10, Color("91a9c8"))

	var stats_card := ColorRect.new()
	stats_card.color = Color(0.025, 0.055, 0.11, 0.88)
	stats_card.position = Vector2(930, 558)
	stats_card.size = Vector2(316, 128)
	stats_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(stats_card)
	_label(canvas, "RUNTIME TELEMETRY", Vector2(952, 578), Vector2(260, 20), 11, ACCENT_CYAN)
	fps_label = _label(canvas, "FPS --  |  Nodes --", Vector2(952, 608), Vector2(270, 22), 15, Color("e9f1ff"))
	status_label = _label(canvas, "LIGHTING  KEY + FILL + RIM", Vector2(952, 640), Vector2(270, 18), 10, Color("91a9c8"))
	_label(canvas, "+  PBR surface study  /  shadowed contact geometry", Vector2(952, 658), Vector2(270, 18), 10, Color("91a9c8"))

func _label(parent: Node, text_value: String, position_value: Vector2, size_value: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = position_value
	label.size = size_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _material(color: Color, roughness: float, metallic: float, emission_color := Color(0, 0, 0, 0)) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	material.specular_mode = BaseMaterial3D.SPECULAR_SCHLICK_GGX
	if emission_color.a > 0.0:
		material.emission_enabled = true
		material.emission = emission_color
		material.emission_energy_multiplier = 2.8
	return material

func _make_normal_texture() -> ImageTexture:
	var image := Image.create(8, 8, false, Image.FORMAT_RGBA8)
	for y in range(8):
		for x in range(8):
			var ripple := 0.5 + sin(float(x) * 0.9) * 0.12 + cos(float(y) * 0.7) * 0.10
			image.set_pixel(x, y, Color(clamp(ripple, 0.0, 1.0), clamp(0.5 + cos(float(x) * 0.8) * 0.1, 0.0, 1.0), 1.0, 1.0))
	return ImageTexture.create_from_image(image)

func _add_static_box(node_name: String, position_value: Vector3, size_value: Vector3, material: StandardMaterial3D) -> Node3D:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position_value
	add_child(body)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "%s_Mesh" % node_name
	var mesh := BoxMesh.new()
	mesh.size = size_value
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	body.add_child(mesh_instance)
	var collision := CollisionShape3D.new()
	collision.name = "%s_Collision" % node_name
	var shape := BoxShape3D.new()
	shape.size = size_value
	collision.shape = shape
	body.add_child(collision)
	return body

func _add_box(node_name: String, position_value: Vector3, size_value: Vector3, material: StandardMaterial3D, parent: Node) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size_value
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position = position_value
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	parent.add_child(mesh_instance)
	return mesh_instance

func _add_cylinder(node_name: String, position_value: Vector3, radius: float, height: float, material: StandardMaterial3D, parent: Node) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius * 0.92
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 32
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position = position_value
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	parent.add_child(mesh_instance)
	return mesh_instance

func _add_sphere(node_name: String, position_value: Vector3, radius: float, material: StandardMaterial3D, parent: Node) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 32
	mesh.rings = 16
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position = position_value
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	parent.add_child(mesh_instance)
	return mesh_instance

func _add_torus(node_name: String, position_value: Vector3, outer_radius: float, inner_radius: float, material: StandardMaterial3D) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := TorusMesh.new()
	mesh.outer_radius = outer_radius
	mesh.inner_radius = inner_radius
	mesh.rings = 48
	mesh.ring_segments = 12
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	mesh_instance.position = position_value
	mesh_instance.rotation_degrees = Vector3(90, 0, 0)
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	add_child(mesh_instance)
	return mesh_instance

func _register_interactable(node: Node3D, display_name: String, material: StandardMaterial3D) -> void:
	interactable_nodes.append(node)
	interactable_names.append(display_name)
	interactable_active.append(false)
	interactable_materials.append(material)

func _update_interactions(delta: float) -> void:
	beacon_orbit += delta
	for index in interactable_nodes.size():
		var node := interactable_nodes[index]
		if is_instance_valid(node):
			if index == 0:
				node.position.y = 3.15 + sin(beacon_orbit * 1.6) * 0.13
			else:
				node.rotation.y += delta * (0.35 + index * 0.08)
			var material := interactable_materials[index]
			material.emission_energy_multiplier = 5.0 if interactable_active[index] else 2.8

func _update_camera(delta: float) -> void:
	if player == null:
		return
	var move := Vector3.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		move.z -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		move.z += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		move.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		move.x += 1.0
	if Input.is_key_pressed(KEY_Q):
		move.y += 1.0
	if Input.is_key_pressed(KEY_Z):
		move.y -= 1.0
	if move.length_squared() > 0.0:
		player.position += move.normalized() * 4.5 * delta
		player.position.x = clamp(player.position.x, -5.5, 5.5)
		player.position.y = clamp(player.position.y, -1.0, 3.0)
		player.position.z = clamp(player.position.z, -1.5, 8.5)

func _update_interface() -> void:
	if fps_label != null:
		fps_label.text = "FPS %d  |  Nodes %d  |  PBR surfaces %d" % [Engine.get_frames_per_second(), get_tree().get_node_count(), 24]
	if prompt_label != null and player != null:
		var nearest := _nearest_index()
		if nearest >= 0:
			prompt_label.text = "[E]  %s  /  %s" % ["Deactivate" if interactable_active[nearest] else "Activate", interactable_names[nearest]]
		else:
			prompt_label.text = "[E]  Move closer to a beacon or pylon"

func _nearest_index() -> int:
	if player == null:
		return -1
	var nearest := -1
	var distance := 2.5
	for index in interactable_nodes.size():
		if not is_instance_valid(interactable_nodes[index]):
			continue
		var current_distance := player.global_position.distance_to(interactable_nodes[index].global_position)
		if current_distance < distance:
			distance = current_distance
			nearest = index
	return nearest

func _toggle_nearest() -> void:
	var nearest := _nearest_index()
	if nearest >= 0:
		interactable_active[nearest] = not interactable_active[nearest]

func _apply_capture_preset() -> void:
	if capture_mode == "feature":
		player.position = Vector3(0.0, 0.4, 3.5)
		camera.position = Vector3(0.0, 3.8, 7.2)
		camera.fov = 48.0
		interactable_active[0] = true
	elif capture_mode == "technical":
		player.position = Vector3(-3.2, 1.3, 6.0)
		camera.position = Vector3(1.4, 3.0, 8.3)
		camera.fov = 52.0
		for index in interactable_active.size():
			interactable_active[index] = index % 2 == 0

func _capture_screenshot(mode: String) -> void:
	var image := get_viewport().get_texture().get_image()
	image.save_png("res://screenshots/%s.png" % mode)
