package game

Vec2i :: [2]int

update :: proc(grid: ^Grid) {
	// esse reverse só funciona pra movimentos pra beixo :( mas foi a gambiarra q pensei na hora
	// gases ou por exemplo um impacto que joga o material pra cima vai quebrar
	#reverse for &cell, i in grid {
		if cell == .AIR do continue
		
		position := get_position(i)
		next_pos := Vec2i{position.x, position.y+1}
		
		if is_position_within_bound(next_pos) {
			if next_cell := get_cell(grid, next_pos); next_cell^ < cell {
				temp := cell
				cell = next_cell^
				next_cell^ = temp
				continue
			}
		}
		next_pos.x -= 1
		if is_position_within_bound(next_pos) {
			if next_cell := get_cell(grid, next_pos); next_cell^ < cell {
				temp := cell
				cell = next_cell^
				next_cell^ = temp
				continue
			}
		}
		next_pos.x += 2
		if is_position_within_bound(next_pos) {
			if next_cell := get_cell(grid, next_pos); next_cell^ < cell {
				temp := cell
				cell = next_cell^
				next_cell^ = temp
				continue
			}
		}
	}
}
