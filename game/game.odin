package game

Vec2i :: [2]int

update :: proc(grid: ^Grid) {
	// esse reverse sepá só funciona pra movimentos pra baixo, nn tenho ctz :( mas foi a gambiarra q pensei na hora.
	// gases ou por exemplo um impacto que joga o material pra cima vai quebrar
	#reverse for cell, i in grid {
		if cell == .AIR do continue
		row_offset := rand.float32_range(0, 1) > .5 ? 1 : -1
		position := get_position(i)
		#partial switch cell {
		case .WATER:
			update_water(position, grid, row_offset)
		case .SAND:
			update_sand(position, grid, row_offset)
		}
	}
}

update_sand :: proc(current_position: Vec2i, grid: ^Grid, row_offset: int) {
	possible_positions := [?]Vec2i{
		{current_position.x, current_position.y+1}, 			// down
		{current_position.x+row_offset, current_position.y+1}, 	// random diagonal
	}

	for possible_position in possible_positions {
		if !is_position_within_bound(possible_position) do continue
			swap_material(grid, current_position, possible_position)
	}
} 

update_water :: proc(current_position: Vec2i, grid: ^Grid, row_offset: int) {
	possible_positions := [?]Vec2i{
		{current_position.x, current_position.y+1},				// down
		{current_position.x+row_offset, current_position.y+1},	// random diagonal
		{current_position.x+row_offset, current_position.y},	// random horizontal
	}

	for possible_position in possible_positions {
		if !is_position_within_bound(possible_position) do continue
			swap_material(grid, current_position, possible_position)
	}
}  

import "core:math/rand"
import "core:fmt"
