use <utils.scad>;

/*
* Render Helpers
*/

function mb_group_render(renderGroups, g, solo = false) =
    solo ? (len(renderGroups) == 1 && renderGroups[0] == g) :
    (mb_in_array(renderGroups, "all") || mb_in_array(renderGroups, g));

/*
* Assembly Helpers
*/

function mb_assembly(config, settings, size, direction) = 
    let(dirInt = mb_direction_to_int(direction),
        assembly = mb_param_assembly(config, settings),
        assemblySize = assembly[1] != undef ? assembly[1] : mb_size_resolve(size, dirInt),
        assemblyDirection = assembly[2] != undef ? mb_direction_resolve(assembly[2], dirInt) : dirInt)
        [assembly[0], assemblySize, assemblyDirection];

function mb_assembly_tongue(assembly, renderGroups, g) = 
    mb_group_render(renderGroups, g, true) ? true :
    assembly[0] != "merged";

function mb_assembly_groove(assembly, renderGroups, g) = 
    mb_group_render(renderGroups, g, true) ? "groove" :
    assembly[0] == "merged" ? "none" : "groove"; 

function mb_assembly_offset(offset, assembly, renderGroups, g) = 
    let(size = assembly[1],
        globalDir = assembly[2],
        oX = assembly != undef && size[1] > size[0] ? 0.5 + size[0] : 0,
        oY = assembly != undef && size[0] >= size[1] ? 0.5 + size[1] : 0)
        
        mb_group_render(renderGroups, g, true) ? [0, 0, 0] :
       (assembly == undef || assembly[0] != "unassembled" ? 
         offset : 
        mb_offset_global_to_local([oX, oY, 0], globalDir));

/*
* General Helpers
*/

function mb_block_id(blockId, part) = str(blockId, "/", part);

function mb_offset_global_to_local(offset, direction) = 
    (direction == 1 || direction == 3) ? [(direction == 1 ? -1 : 1) * offset[1], (direction == 3 ? -1 : 1) * offset[0], offset[2]] : [(direction == 2 ? -1 : 1) * offset[0], (direction == 2 ? -1 : 1) * offset[1], offset[2]];

function mb_size_resolve(size, direction) = direction % 2 == 1 ? [size[1], size[0], size[2]] : size;
function mb_direction_resolve(dir1, dir2) = (dir1 + dir2) % 4;

/*
* Composite Block Helpers
*/

function _mb_vec3_min(a, b) = [
    min(a[0], b[0]),
    min(a[1], b[1]),
    min(a[2], b[2])
];

function _mb_vec3_max(a, b) = [
    max(a[0], b[0]),
    max(a[1], b[1]),
    max(a[2], b[2])
];

// entry = [size, direction, offset]
function _mb_part_min(entry) =
    let(
        offset = entry[3]
    )
    offset;

function _mb_part_max(entry) =
    let(
        size = entry[1],
        direction = entry[2],
        offset = entry[3],
        size_resolved = mb_size_resolve(size, mb_direction_to_int(direction))
    )
    [
        offset[0] + size_resolved[0],
        offset[1] + size_resolved[1],
        offset[2] + size_resolved[2]
    ];

function mb_parts_total_size(parts, i = 0, min_v = undef, max_v = undef) =
    i >= len(parts)
        ? [
            max_v[0] - min_v[0],
            max_v[1] - min_v[1],
            max_v[2] - min_v[2]
          ]
        : let(
            part = parts[i],
            part_min = _mb_part_min(part),
            part_max = _mb_part_max(part),
            next_min = (i == 0) ? part_min : _mb_vec3_min(min_v, part_min),
            next_max = (i == 0) ? part_max : _mb_vec3_max(max_v, part_max)
          )
          mb_parts_total_size(parts, i + 1, next_min, next_max);


function mb_set_step_print_position(assembly, steps, step) = 
    let(size = steps[step - 1][1],
        apply_assembly = steps[step - 1][2])
    step == 0 ? [0, 0, 0] : [((assembly == "unassembled" || assembly[0] == "unassembled") && apply_assembly && (size[0] < size[1]) ? 2 : 1) * (size[0] + 0.5) + mb_set_step_print_position(assembly, steps, step - 1)[0], 0, 0];
