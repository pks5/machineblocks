use <../core/block_model.scad>;
use <../core/block_dim.scad>;
use <../core/block_part.scad>;

/**
* ------
* Grille
* ------
*/
function mb_block_part__grille(block_obj) = 
    let(grille = mb_block_get_grille(block_obj))
    grille == "none" ? undef :
    let(
        block_dim = mb_block_get_dim(block_obj),
        mod_size = mb_block_dim_mod_size(block_dim),
        
        is_grille_inverted = mb_block_is_grille_inverted(block_obj),
        grille_depth = mb_block_get_grille_depth(block_obj),
        grille_count = mb_block_get_grille_count(block_obj),
        grille_width = 1 / grille_count,
        min_max_index = mb_block_dim_min_max_index(block_dim),
        min_index = min_max_index[0][grille == "x" ?  1 : 0], 
        max_index = min_max_index[1][grille == "x" ?  1 : 0],
        top = mb_block_dim_face_edge_expand(
            block_dim, 
            adjusted = true, 
            face = "z+", 
            overlap = true
        )
    )
    mb_block_part_model(
        type = "list",
        name = "grille",
        items = [
            for(i = [min_index : max_index])
                for(j = [0 : grille_count - 1])
                    if(j % 2 == (is_grille_inverted ? 0 : 1))
                    mb_block_part_cube(
                        block_dim = block_dim,
                        size = [
                            grille == "x" ? undef : (grille_width + mb_block_dim_overlap(block_dim, overlap = 2)), 
                            grille == "y" ? undef : (grille_width + mb_block_dim_overlap(block_dim, overlap = 2)), 
                            grille_depth + mb_block_dim_overlap(block_dim, overlap = true)
                        ],
                        expand = [
                            for(f = [0 : 3])
                                0,
                            "auto", 
                            top
                        ],
                        offset = mb_block_pos_to_offset(block_obj, [grille == "x" ? undef : 0.5*grille_width + i + j * grille_width, grille == "y" ? undef : 0.5*grille_width + i + j * grille_width, undef])
                    )
        ]   
    );