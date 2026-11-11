# Complete Blender Environment Build — Claude Production Instructions

## Assignment
Act as a senior stylized 3D environment artist and technical artist. **Create and validate an actual Blender scene**, not merely a written plan or disconnected concept images. Forest Spirit Shrine is a compact original fantasy environment. Target a polished animated-feature look, soft geometric silhouettes and convincing stylized materials without photorealism.

## Reference policy
- JSON scene manifest and master top-down govern numerical geometry and spatial layout.
- The eight directional sheets show construction relationships. They are **schematic illustrations, not genuine rendered multi-angle photographs**.
- Shrine turnaround controls approximate architecture from front, back, left, right, top.
- Style direction sheet controls atmosphere and art style only.
- When illustrations conflict, the numerical manifest always wins.
- The final scene must have one stable layout seen from real cameras.

## Creative requirements
Make a small tranquil forest clearing with a moss-covered segmented arch shrine near the northern edge, stepped platform, levitating turquoise crystal, two rune pillars, one large twisted tree on the western side, a medium tree on the eastern side, lighter perimeter trees, flowers, ferns, mushroom clusters, scattered old limestone rocks, readable stepping-stone pathway from the southern entrance, and two collectible blue spirit orbs. Warm filtered sunlight, muted dark green and sage foliage, stone gray, natural bark browns and modest cyan emissive accents. No characters, combat, big maps, waterfalls, or unnecessary features.

## Coordinates and camera contract
One meter per Blender unit. Manifest is X east, Y up, Z south, with north = negative Z. Blender is Z-up: map manifest (x,y,z) to Blender (x,z,y). Do not mirror the site. Site 24×24m, core playable area ~18m diameter, player begins at southern entrance (0,0,+9.5), shrine platform center (0,0,-4.07). Position all trees, pillars and orbs using manifest coordinates. Rebuild named south, north, east, west, southeast, southwest, northeast and northwest cameras from the manifest. Add an orthographic top view. Render all nine **from the same constructed world**.

## Deliverables
Create a fresh directory `Forest_Spirit_Shrine_Production` with:
```
blender/Forest_Spirit_Shrine_MASTER.blend
scripts/build_scene.py
scripts/validate_assets.py
exports/forest_shrine_scene.glb
exports/modular/*.glb
exports/textures/*
renders/final_south.png
renders/final_north.png
renders/final_east.png
renders/final_west.png
renders/final_southeast.png
renders/final_southwest.png
renders/final_northeast.png
renders/final_northwest.png
renders/final_topdown.png
renders/altar_front.png
renders/altar_left.png
renders/altar_back.png
renders/altar_right.png
reports/ASSET_REGISTER.csv
reports/MATERIALS.md
reports/GODOT_IMPORT.md
reports/QA_RESULTS.md
README.md
```

## Practical construction stages
1. **Inspect tools:** Check for Blender, Python and optional Tripo access. If Blender is unavailable, provide a reproducible Blender script and explicitly describe the blocker. Never claim an unexecuted render.
2. **Greybox:** Set site, camera positions, path and fixed anchors before detailed work. Validate orientation from south, west and overhead.
3. **Shrine:** Individually model ring stones with bevels, moss and clean pivots; layered stone platform and steps; glowing center crystal; separate rune pillars and worn stone accents. Main ring width roughly 4.8m, top at 4.29m.
4. **Natural forms:** Build one distinctive twisting oak, derive several simpler perimeter trees, create rock modules and repeatable leaf, fern and grass clumps with deliberately controlled density.
5. **Materials:** Consistent stylized PBR-lite textures and roughness, selective weathering, warm highlights, cool shadows, non-photographic proportions. Prioritize silhouette, composition and cohesion over tiny detail.
6. **Lighting:** One economical directional sunlight, ambient fill, optional baked/painted shade cues and restrained emissive materials. No reliance on heavy real-time GI or volumetrics.
7. **Integration:** Keep modular geometry and meaningful object names, correct transforms/pivots, UVs and Godot-compatible materials. Export GLB; validate material maps after import.
8. **Validation:** Render from all cameras of one scene, compare landmarks and orientations, inspect for broken imports, missing textures, floating stones, obstructed paths and duplicated/mirrored geometry. Provide evidence of actual commands and generated files.

## Tripo usage
Tripo multi-view generation applies to **individual props**. Supply coherent object front/left/back/right references when available. Do not feed the whole forest views as if they were object scans. Check and repair UVs, normal orientation, topology, geometry count and pivots.

## Integrated GPU constraints
Windows office laptop, 16GB RAM, no discrete GPU. Godot 4 Compatibility. Begin at 1280×720, aim for stable 30FPS **only after on-device measurement**. Reuse instanced geometry, material atlases where feasible, 512–1024px textures primarily, mostly opaque/cutout leaves, conservative real-time shadows and limited particles. Keep rendering and asset budgets flexible and test actual bottlenecks.

## Reporting and handoff
The response must include verified file paths, the generated Blender master, GLB exports, full set of genuine angle renders, validation details, unimplemented items, and import notes for Codex. Do not make unsupported claims about quality, rendering, playability, or measured frame rate. All outputs and instructions in English.
