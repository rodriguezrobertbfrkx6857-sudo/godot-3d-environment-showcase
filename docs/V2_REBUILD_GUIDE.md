# V2 Art Rebuild Guide

## Design priorities (highest first)
1. **Hero oak:** replace the smooth capsule-like crown with a twisting, tapered trunk, exposed roots, readable branch bifurcation, and layered clusters of broad foliage. Reserve negative-space windows that frame the shrine.
2. **Shrine architecture:** keep the specified footprint and approach, but replace the perfect ring with individually modeled bevelled stone blocks, a recognizable keystone, localized moss, minor crack/deformation patterns, and coherent carved motifs.
3. **Forest floor:** avoid empty homogeneous grass. Model patches of soil, compact grass, mossy rock edges, roots, fern groups, wildflowers and mushrooms around the path and under trees. Favor purposeful clusters, not dense random scattering.
4. **Path:** use multiple silhouettes, varied stone thickness and rotation, partly buried slabs and dirt/moss transitions without obstructing player movement.
5. **Light and staging:** warm directional sunlight, cool ambient fill, controlled shadow shapes and atmosphere. Detail should remain readable in actual game camera views.

## Technical workflow
Preserve original coordinate manifest and use Blender import for the legacy GLB to extract useful assets. Recreate broken hero elements; retain only viable modular or collision/reference meshes. Make a master .blend and render all shots from one consistent scene.

Build an eye-level hero section FIRST. Required camera points, in manifest convention:
- SOUTH_PLAYER: (0,1.7,8.8), aim (0,2.0,-4.2).
- SOUTHEAST_PLAYER: (4.2,1.7,4.5), aim (0,2.2,-4.3).
- Tree, shrine, and ground details at 2–3m distance.
- Orthographic top view, and final compass turnarounds once art has passed review.

Blender is Z-up; manifest is Y-up. Convert consistently. Game target is Godot 4 Compatibility on Windows integrated graphics, 16GB RAM. Establish editable modular materials and a light profile with shader features supported in the target renderer.

## Do not do
- Inflate geometry without improving silhouettes and surface design.
- Replace the playable forest scene with a non-playable painted render.
- Start an entire new level with no connection to the given GLB and manifest.
- Produce eight disconnected images that contradict spatial layout.
- Say a .blend was tested if Blender is absent.
- Promise a frame rate without a target machine performance test.

## Required assets and final packaging
All exported GLBs, Blender master file, source scripts, textures, high-quality renders, shrine turnaround, design/source references, collision/anchor notes, QA report, asset register, and Godot import instructions must be inside the final project ZIP.
