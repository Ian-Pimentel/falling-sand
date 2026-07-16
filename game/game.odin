package game

Vec2i :: [2]int

update :: proc(grid: ^Grid) {
	cells_updated := 0
	for &cell, i in grid {
		if cell.material == .AIR || cell.updated do continue
		
		row_offset := rand.float32_range(0, 1) > .5 ? 1 : -1
		position := get_position(i)

		cells_updated += 1
		cell.updated = true
		#partial switch cell.material {
		case .WATER:
			update_water(position, grid, row_offset)
		case .SAND:
			update_sand(position, grid, row_offset)
		}
	}

	for &cell, i in grid do cell.updated = false
	fmt.printfln("cells updated => %i", cells_updated)
}

update_sand :: proc(current_position: Vec2i, grid: ^Grid, row_offset: int) {
	possible_positions := [?]Vec2i{
		{current_position.x, current_position.y+1}, 			// down
		{current_position.x+row_offset, current_position.y+1}, 	// random diagonal
	}

	for possible_position in possible_positions {
		if !is_position_within_bound(possible_position) do continue
			swap_cells(grid, current_position, possible_position)
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
			swap_cells(grid, current_position, possible_position)
	}
}  

import "core:math/rand"
import "core:fmt"
