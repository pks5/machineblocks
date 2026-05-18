use <utils.scad>;

function mb_block_dim(block_size, block_mod = undef) =
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
        
        min_max_pos = [
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
            min_max_pos
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

function mb_block_dim_size(block_dim) =                          block_dim[0][0];
function mb_block_dim_size_bounding_box(block_dim) =             block_dim[0][1];
function mb_block_dim_center(block_dim) =                        block_dim[0][2];
function mb_block_dim_size_mod(block_dim) =                      block_dim[0][3];

function mb_block_dim_mod_size(block_dim) =                      block_dim[1][0];
function mb_block_dim_mod_size_bounding_box(block_dim) =         block_dim[1][1];

function mb_block_dim_min_max_pos(block_dim) =                   block_dim[1][2];
function mb_block_dim_min_max_index(block_dim) =                 block_dim[3];