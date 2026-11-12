# Forest Spirit Shrine V2 — Claude Art Rebuild Instructions

## What went wrong
The old 65.5 MiB project ZIP has valid GLB geometry but visually reads as a plain procedural blockout. Its original master .blend and FBX are missing. The 106 automatic checks only validate structure, not art. The earlier GitHub reference branch contained vector diagrams rather than the high-resolution painted target, which is a critical art-direction gap.

## Inputs (both must be available)
1. Original Forest_Spirit_Shrine_Complete_Project.zip with GLBs, scripts, manifest and renders.
2. The original high-resolution fantasy shrine concept PNG, supplied separately by the user. **Do not substitute the schematic STYLE_DIRECTION.svg for the painted visual target.** The PNG is the mood/style target, not a dimensional blueprint.

## Objective
Actually rebuild the 3D art to a polished, cohesive animated-feature-style forest scene. **Do not just increase subdivision, change bloom/fog or rerun 106 technical tests.** Preserve the source manifest, coordinates, gameplay anchors and exports as a graybox foundation, but replace visibly weak hero assets.

## Critical stage gate — FIRST BEAUTY SHOT
Before producing the full 24m site, create a 5–8m hero slice: one unique large twisting oak on the west, the segmented stone shrine and 5m of foreground soil/path. Build real Blender assets, materials, lighting and a few foliage clusters.
- Hero oak: exposed roots, readable tapered branches, leaf/branch silhouettes, gaps framing the shrine. **No giant smooth balloon-like canopy blobs**.
- Shrine: varied stone blocks, cracks, wear, carved keystone motif, localized moss and vine details, expressive crystal. Preserve platform geometry and access.
- Ground: mix soil, grass, moss, roots and stones, layered ferns and flowers. **No uniform empty lawn**.
- Path: 4+ irregular slab silhouettes, moss/earth transitions, walkable corridor. **No straight row of nearly identical rectangles**.
- Lighting: warm sun through foliage, cooler shadows, limited haze and controllable exposure. Make models good before post-processing.

### Game-space camera specs
Axes: +X east, +Y up, +Z south, -Z north.
- Hero eye-level: position (0, 1.70, 8.8), aim (0, 2.0, -4.2), vertical FOV ~50 degrees.
- Second eye-level: position (4.2, 1.70, 4.5), aim (0, 2.2, -4.3).
- Shrine and hero trunk detail shots from 2–3m distances.
All images must come from ONE actual 3D scene.

### Phase A output required
- Editable and REOPEN-TESTED .blend master.
- Exports of rebuilt shrine and oak in .glb.
- beauty_south_eye_level.png; beauty_southeast_eye_level.png; hero_oak_detail.png; shrine_material_detail.png; ground_detail.png.
- Side-by-side comparison with the user-supplied high-resolution concept art.
**STOP after the beauty shot for visual approval** before making another hundred average-quality objects.

## Phase B: expand only after approval
Rebuild remaining trees as at least 3 distinct silhouette families using reusable foliage clusters. Increase strategic greenery in foreground/under trees/around shrine, not random uniform scatter. Layer backdrop to create depth while keeping shrine readable. Add small narrative details in a controlled way. Retain the original shrine, orbs, pillars and entrance anchors and functional clearance.

## Technical conditions
- Target: 16GB RAM, integrated GPU, Godot 4 Compatibility.
- Visual master first; optimize game runtime separately using shared materials, instance clusters, LODs, reduced overdraw and mostly 512–1024px textures.
- FPS cannot be claimed without an actual on-device Godot test.
- Must provide .blend, .glb, texture dependencies, same-scene directional renders, updated asset list, QA report and a verified final ZIP.
- The original Blender generator was only stub-tested; do not label an unexecuted Python script as a completed Blender scene.
- If Blender is unavailable, report it and stop claiming that art production and true 3D rendering are finished.
- Use English-only filenames, instructions and reports.

## Acceptance
Reject if the hero tree still resembles smooth inflated bubbles, the grass is mostly an empty green field, the shrine is a perfect stack of identical blocks, or the only evidence is distant aerial renders. Approve the full scene only after a convincing **player-eye-height** beauty shot, shrine closeup, oak closeup and ground patch closeup exist as actual renders.
