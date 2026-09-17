# Scene Breakdown

## Intent

Nocturne Atrium is a deliberately small real-time environment study. The
composition uses a central luminous object, two approach pylons, repeated
columns, and inset floor lines to demonstrate scale, focal hierarchy, and
readable navigation without depending on imported assets.

## Runtime hierarchy

```text
EnvironmentShowcase (Node3D)
├── WorldEnvironment
├── DirectionalKeyLight
├── OmniCyanFill
├── SpotAmberKey
├── AtriumFloor (StaticBody3D)
│   ├── AtriumFloor_Mesh
│   └── AtriumFloor_Collision
├── BackWall / LeftWall / RightWall (StaticBody3D)
├── CentralPlinth (StaticBody3D)
├── LumenBeacon (MeshInstance3D)
├── BeaconRing / BeaconRing_Upper
├── Pylon_0 / Pylon_1
├── Columns and planters
├── FreeCameraRig
│   └── ShowcaseCamera
└── PortfolioHUD (CanvasLayer)
```

The hierarchy is constructed in `src/showcase_main.gd` so the project can be
opened without an asset import step. The static-body helpers create a visual
mesh and a matching `BoxShape3D` together, which reduces the chance of a
visual/collision mismatch.

## Lighting pipeline

1. A dark blue world background and low-energy ambient light establish the
   night-time base.
2. A cool directional key light provides a consistent shadow direction.
3. A cyan omni fill supports the hero object and adds color separation.
4. A warm spot light creates a contrasting pool of light from the upper right.
5. Filmic tonemapping and glow are enabled for the emissive accents.

The three light types have different jobs rather than being added only for
quantity. Shadows are enabled on all three so contact and cast-shadow behavior
can be inspected in the running scene.

## Material pipeline

The `_material()` helper creates `StandardMaterial3D` instances with explicit
albedo, roughness, metallic, specular, and optional emission values. The cyan
trim additionally receives a small procedural normal texture and normal scale.
The floor is intentionally rough and only slightly metallic; the beacon and
trim are smoother and more reflective. This contrast is visible even with
primitive geometry.

## Interaction and camera

The camera rig supports WASD/arrow movement, Q/Z vertical movement, mouse look
after clicking the viewport, and E to toggle the nearest beacon or pylon. The
HUD exposes the current interaction target, FPS, scene node count, and material
count. Interactable emission energy changes at runtime, making the input result
visually verifiable.

## Optimization decisions

- No external asset download or runtime network request.
- Primitive meshes are reused conceptually through small helper functions.
- The scene is intentionally kept below a small environment scale: 24 PBR
  surfaces, three shadowed lights, and a limited number of visible nodes.
- Collision shapes are simple boxes instead of triangle meshes.
- UI updates are text-only and do not allocate new controls every frame.

## Problems and solutions

- **Problem:** A large environment would hide whether composition or asset
  volume caused visual issues. **Solution:** constrain the scene to a single
  atrium and make the focal hierarchy explicit.
- **Problem:** Imported assets would introduce license and missing-resource
  risks. **Solution:** use Godot primitives and document the decision here.
- **Problem:** Lighting can look attractive while remaining hard to inspect.
  **Solution:** expose a runtime telemetry panel and keep key/fill/rim roles
  named in the scene hierarchy.
