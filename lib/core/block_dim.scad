use <utils.scad>;

//TODO Rename
function mb_block_mod_min_max(block_size, block_mod = undef) =
    let(
        size = mb_resolve_xyz(xyz = block_size, default = [1, 1, 1]),
        mod = mb_qc_resolve(qc = block_mod, cube = true),
        
        bb = mb_bounding_box(size),
        c = [
            0.5 * bb[0], 
            0.5 * bb[1], 
            0.5 * bb[2]
        ],
        
        mi = [
            -mod[0], 
            -mod[2], 
            -mod[4]
        ],
        ma = [
            size[0] + mod[1], 
            size[1] + mod[3], 
            size[2] + mod[5]
        ],
        
        mod_size = [
            size[0] + mod[0] + mod[1],
            size[1] + mod[2] + mod[3],
            size[2] + mod[4] + mod[5]
        ],
        
        min_max = [
            [
                mi[0] - c[0], 
                mi[1] - c[1], 
                mi[2] - c[2]
            ], // min from org center
            [
                ma[0] - c[0], 
                ma[1] - c[1], 
                ma[2] - c[2]
            ] // max from org center
        ],
    )
    [
        [
            size, 
            bb, 
            c, 
            mod
        ], // 0
        
        [
            mod_size,
            mb_bounding_box(mod_size),
            min_max
        ], // 1
        
        [
            mi, 
            ma
        ], // 2

        [ 
            [
                floor(mi[0]), 
                floor(mi[1]), 
                floor(mi[2]), 
            ], // Min Index (modified)
            [
                ceil(ma[0] - 1), 
                ceil(ma[1] - 1), 
                ceil(ma[2] - 1)
            ] // Max Index (modified)
        ] // 3
    ];