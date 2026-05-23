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

function mb_block_dim_size_expand(block_dim, size, expand) = 
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        
        si = is_undef(size) ? mod_size : size,
        si2 = [
            (is_undef(si[0]) ? mod_size[0] : si[0]), 
            (is_undef(si[1]) ? mod_size[1] : si[1]), 
            (is_undef(si[2]) ? mod_size[2] : si[2])
        ],
        s_adj = is_undef(expand) || expand == "auto" || expand == ["auto", "auto", "auto"] ? 
            si2 :

            [
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        -0.5 * si2[0] : expand[0] == "auto" ? 
                        (0.5 * mod_size[0] + expand[1] - si2[0]) : 
                        -0.5 * (expand[1] == "auto" ? mod_size[0] : si2[0]) - expand[0],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        -0.5 * si2[1] : expand[2] == "auto" ? 
                        (0.5 * mod_size[1] + expand[3] - si2[1]) : 
                        -0.5 * (expand[3] == "auto" ? mod_size[1] : si2[1]) - expand[2],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        -0.5 * si2[2] : expand[4] == "auto" ? 
                        (0.5 * mod_size[2] + expand[5] - si2[2]) : 
                        -0.5 * (expand[5] == "auto" ? mod_size[2] : si2[2]) - expand[4]
                ],
                [
                    expand[0] == "auto" && expand[1] == "auto" ? 
                        0.5 * si2[0] : expand[1] == "auto" ? 
                        (-0.5 * mod_size[0] - expand[0] + si2[0]) : 
                        0.5 * (expand[0] == "auto" ? mod_size[0] : si2[0]) + expand[1],
                    expand[2] == "auto" && expand[3] == "auto" ? 
                        0.5 * si2[1] : expand[3] == "auto" ? 
                        (-0.5 * mod_size[1] - expand[2] + si2[1]) : 
                        0.5 * (expand[2] == "auto" ? mod_size[1] : si2[1]) + expand[3],
                    expand[4] == "auto" && expand[5] == "auto" ? 
                        0.5 * si2[2] : expand[5] == "auto" ? 
                        (-0.5 * mod_size[2] - expand[4] + si2[2]) : 
                        0.5 * (expand[4] == "auto" ? mod_size[2] : si2[2]) + expand[5]
                ]
            ])
    s_adj;

function mb_block_dim_this_offset(block_dim, off = 0, adjusted = false, face = "z-", overlap = false) =
    let(
        face = mb_face_to_int(face = face),
        base_adj = mb_block_dim_base_adj(block_dim)
    )
    (adjusted ? base_adj[face == 5 ? 5 : 4] : 0) - off + mb_block_dim_overlap(block_dim, overlap = overlap);

function mb_block_dim_opposite_offset(block_dim, off = 0, adjusted = false, face = "z+", overlap = false) =
    let(
        mod_size = mb_block_dim_mod_size(block_dim),
        base_adj = mb_block_dim_base_adj(block_dim),
        face = mb_face_to_int(face = face)
    )
    (adjusted ? -base_adj[face == 4 ? 5 : 4] : 0) - (mod_size[2] - off) + mb_block_dim_overlap(block_dim, overlap = overlap);

function mb_block_dim_face_edge_expand(block_dim, exp = 0, adjusted = false, face = "x-", overlap = false) =
    let(
        face = mb_face_to_int(face = face),
        base_adj = mb_block_dim_base_adj(block_dim)
    )
    (adjusted ? base_adj[face < 6 ? face : 0] : 0) + exp + mb_block_dim_overlap(block_dim, overlap = overlap);