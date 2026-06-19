use <utils.scad>;

function mb_block_dim(size, size_mod = undef, base_adj = undef, bevel = undef, slope = undef) =
    let(
        size = mb_resolve_xyz(xyz = size, default = [1, 1, 1]),
        mod = mb_qc_resolve(qc = size_mod, cube = true),
        bsa = mb_qc_resolve(qc = base_adj, cube = true),
        
        bb = mb_bounding_box(size),
        c = [
            0.5 * bb[0], 
            0.5 * bb[1], 
            0.5 * bb[2]
        ],
        
        
        
        mod_size = [
            size[0] + mod[0] + mod[1],
            size[1] + mod[2] + mod[3],
            size[2] + mod[4] + mod[5]
        ],

        bevel = mb_bevel_resolve(bevel, mod_size),
        slope = mb_slope_resolve(slope, mod_size),
        slope_neg = mb_slope_filter(slope, -1, 1),
        slope_pos = mb_slope_filter(slope, 1, 1),

        adj_size = [
            mod_size[0] + bsa[0] + bsa[1],
            mod_size[1] + bsa[2] + bsa[3],
            mod_size[2] + bsa[4] + bsa[5],
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

        mi_top = [
            mi[0] + slope_pos[0],
            mi[1] + slope_pos[2],
            mi[2]
        ],

        ma_top = [
            ma[0] - slope_pos[1],
            ma[1] - slope_pos[3],
            ma[2]
        ],

        mi_bottom = [
            mi[0] + slope_neg[0],
            mi[1] + slope_neg[2],
            mi[2]
        ],

        ma_bottom = [
            ma[0] - slope_neg[1],
            ma[1] - slope_neg[3],
            ma[2]
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

        min_max_pos_top = [
            [
                mi_top[0] - c[0], 
                mi_top[1] - c[1], 
                mi_top[2] - c[2]
            ], // min from org center
            [
                ma_top[0] - c[0], 
                ma_top[1] - c[1], 
                ma_top[2] - c[2]
            ] // max from org center
        ],

        min_max_pos_bottom = [
            [
                mi_bottom[0] - c[0], 
                mi_bottom[1] - c[1], 
                mi_bottom[2] - c[2]
            ], // min from org center
            [
                ma_bottom[0] - c[0], 
                ma_bottom[1] - c[1], 
                ma_bottom[2] - c[2]
            ] // max from org center
        ],

        min_index = [
            floor(mi[0]), 
            floor(mi[1]), 
            floor(mi[2]), 
        ], 
        max_index = [
            ceil(ma[0] - 1), 
            ceil(ma[1] - 1), 
            ceil(ma[2] - 1)
        ],

        min_index_top = [
            floor(mi_top[0]), 
            floor(mi_top[1]), 
            floor(mi_top[2]), 
        ], 
        max_index_top = [
            ceil(ma_top[0] - 1), 
            ceil(ma_top[1] - 1), 
            ceil(ma_top[2] - 1)
        ],

        min_index_bottom = [
            floor(mi_bottom[0]), 
            floor(mi_bottom[1]), 
            floor(mi_bottom[2]), 
        ], 
        max_index_bottom = [
            ceil(ma_bottom[0] - 1), 
            ceil(ma_bottom[1] - 1), 
            ceil(ma_bottom[2] - 1)
        ],

        bevel_matrix = mb_bevel_matrix(bevel, mod_size, min_max_pos),

        
        overlap_length = 0.01
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
            min_index, // Min Index (modified)
            max_index // Max Index (modified)
        ], // 3
        [ 
            min_index_top, // Min Index Top
            max_index_top // Max Index Top
        ], // 4
        [ 
            min_index_bottom, // Min Index Bottom
            max_index_bottom // Max Index Bottom
        ], // 5
        undef, // 6
        undef, // 7
        [adj_size, bsa],  // 8
        [bevel, bevel_matrix, slope], // 9
        overlap_length  // 10
    ];

/*
* ------
* GETTER
* ------
*/

function mb_block_dim_size(block_dim) =                          block_dim[0][0];
function mb_block_dim_size_bounding_box(block_dim) =             block_dim[0][1];
function mb_block_dim_center(block_dim) =                        block_dim[0][2];
function mb_block_dim_size_mod(block_dim) =                      block_dim[0][3];

function mb_block_dim_mod_size(block_dim) =                      block_dim[1][0];
function mb_block_dim_mod_size_bounding_box(block_dim) =         block_dim[1][1];

function mb_block_dim_min_max_pos(block_dim) =                   block_dim[1][2];

function mb_block_dim_min_max_index(block_dim) =                 block_dim[3];
function mb_block_dim_min_max_index_top(block_dim) =             block_dim[4];
function mb_block_dim_min_max_index_bottom(block_dim) =          block_dim[5];

function mb_block_dim_adj_size(block_dim) =                      block_dim[8][0];
function mb_block_dim_base_adj(block_dim) =                      block_dim[8][1];

function mb_block_dim_bevel(block_dim) =                         block_dim[9][0];
function mb_block_dim_bevel_matrix(block_dim) =                  block_dim[9][1];
function mb_block_dim_slope(block_dim) =                         block_dim[9][2];

function mb_block_dim_overlap(block_dim, overlap = false) =
    let(overlap_length = block_dim[10])
    (is_num(overlap) ? overlap * overlap_length : overlap == true ? overlap_length : 0);

/*
* -------
* METHODS
* -------
*/
function mb_block_dim_height_expand(block_dim, axis, height, expand) = 
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        min_max_pos = mb_block_dim_min_max_pos(block_dim),
        axis = mb_axis_to_int(axis),
        start = min_max_pos[0][axis],
        end = min_max_pos[1][axis],
        h_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto"] 
        ? [
            !is_undef(height) ? -0.5 * height : start,
            !is_undef(height) ? 0.5 * height : end
        ]
        : [
            expand[0] == "auto" ? end + expand[1] - (!is_undef(height) ? height : mod_size[axis]) : start - expand[0], 
            expand[1] == "auto" ? start - expand[0] + (!is_undef(height) ? height : mod_size[axis]) : end + expand[1]
        ]
    )
    h_adj;

function mb_block_dim_size_expand(block_dim, size, expand) = 
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        min_max_pos = mb_block_dim_min_max_pos(block_dim),

        size_min_max = [
            [
                is_undef(size[0]) ? min_max_pos[0][0] : -0.5 * size[0],
                is_undef(size[1]) ? min_max_pos[0][1] : -0.5 * size[1],
                is_undef(size[2]) ? min_max_pos[0][2] : -0.5 * size[2]
            ],
            [
                is_undef(size[0]) ? min_max_pos[1][0] : 0.5 * size[0],
                is_undef(size[1]) ? min_max_pos[1][1] : 0.5 * size[1],
                is_undef(size[2]) ? min_max_pos[1][2] : 0.5 * size[2]
            ]
        ],
        
        si2 = [
            (is_undef(size[0]) ? mod_size[0] : size[0]), 
            (is_undef(size[1]) ? mod_size[1] : size[1]), 
            (is_undef(size[2]) ? mod_size[2] : size[2])
        ],
        s_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto", "auto"] ? 
            si2 :

            [
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        size_min_max[0][0] : expand[0] == "auto" ? 
                        (min_max_pos[1][0] + expand[1] - si2[0]) : 
                        (expand[1] == "auto" ? min_max_pos[0][0] : size_min_max[0][0]) - expand[0],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        size_min_max[0][1] : expand[2] == "auto" ? 
                        (min_max_pos[1][1] + expand[3] - si2[1]) : 
                        (expand[3] == "auto" ? min_max_pos[0][1] : size_min_max[0][1]) - expand[2],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        size_min_max[0][2] : expand[4] == "auto" ? 
                        (min_max_pos[1][2] + expand[5] - si2[2]) : 
                        (expand[5] == "auto" ? min_max_pos[0][2] : size_min_max[0][2]) - expand[4]
                ],
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        size_min_max[1][0] : expand[1] == "auto" ? 
                        (min_max_pos[0][0] - expand[0] + si2[0]) : 
                        (expand[0] == "auto" ? min_max_pos[1][0] : size_min_max[1][0]) + expand[1],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        size_min_max[1][1] : expand[3] == "auto" ? 
                        (min_max_pos[0][1] - expand[2] + si2[1]) : 
                        (expand[2] == "auto" ? min_max_pos[1][1] : size_min_max[1][1]) + expand[3],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        size_min_max[1][2] : expand[5] == "auto" ? 
                        (min_max_pos[0][2] - expand[4] + si2[2]) : 
                        (expand[4] == "auto" ? min_max_pos[1][2] : size_min_max[1][2]) + expand[5]
                ]
            ])
    s_adj;

/**
* deprecated
*/
function mb_block_dim_this_offset(block_dim, off = 0, adjusted = false, face = "z-", overlap = false) =
    let(
        face = mb_face_to_int(face = face),
        base_adj = mb_block_dim_base_adj(block_dim)
    )
    (adjusted ? base_adj[face] : 0) - off + mb_block_dim_overlap(block_dim, overlap = overlap);

function mb_block_dim_opposite_offset(block_dim, off = 0, adjusted = false, face = "z+", overlap = false) =
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        base_adj = mb_block_dim_base_adj(block_dim),
        face = mb_face_to_int(face = face),
        axis = mb_face_to_axis(face),
        face_opposite = mb_face_opposite(face)
    )
    (adjusted ? -base_adj[face_opposite] : 0) - (mod_size[axis] - off) + mb_block_dim_overlap(block_dim, overlap = overlap);

function mb_block_dim_face_edge_expand(block_dim, exp = 0, adjusted = false, face = "x-", overlap = false, opposite = false) =
    opposite ? mb_block_dim_opposite_offset(block_dim, off = exp, adjusted = adjusted, face = face, overlap = overlap) :
    let(
        face = mb_face_to_int(face = face),
        base_adj = mb_block_dim_base_adj(block_dim)
    )
    face < 6 ? (adjusted ? base_adj[face] : 0) + exp + mb_block_dim_overlap(block_dim, overlap = overlap) : undef;