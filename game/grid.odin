package game

GRID_WIDTH :: 100
GRID_HEIGHT :: 100
GRID_LENGTH :: GRID_WIDTH * GRID_HEIGHT

Grid :: [GRID_LENGTH]Material

init_grid :: proc(grid: ^Grid) {
	grid^ = Grid{}
}

is_index_valid :: proc(index: int) -> bool {
	if index < 0 || index >= GRID_LENGTH do return false
	return true
}

is_position_within_bound :: proc(position: Vec2i) -> bool {
	if position.x < 0 || position.x >= GRID_WIDTH || position.y < 0 || position.y >= GRID_HEIGHT do return false
	return true
}

get_position :: proc(index: int) -> Vec2i {
	assert(is_index_valid(index))
	
	return Vec2i{index % GRID_WIDTH, index / GRID_WIDTH}
}

get_index :: proc(position: Vec2i) -> int {
	assert(is_position_within_bound(position))
	return (position.y * GRID_WIDTH) + position.x
}

get_cell_by_position :: proc(grid: ^Grid, position: Vec2i) -> ^Material{
	assert(is_position_within_bound(position))
	return &grid[get_index(position)]
}
get_cell_by_index :: proc(grid: ^Grid, index: int) -> ^Material{
	assert(is_index_valid(index))
	return &grid[index]
}
get_cell :: proc{get_cell_by_position, get_cell_by_index}

set_cell_by_index :: proc(grid: ^Grid, index: int, material: Material){
	assert(is_index_valid(index))
	grid[index] = material
}
set_cell_by_position :: proc(grid: ^Grid, position: Vec2i, material: Material) {
	assert(is_position_within_bound(position))
	grid[get_index(position)] = material
}
set_cell :: proc{set_cell_by_position, set_cell_by_index}

try_set_cell :: proc(grid: ^Grid, position: Vec2i, material: Material) {
	if !is_position_within_bound(position) do return
	grid[get_index(position)] = material
}

swap_material :: proc(grid: ^Grid, source_pos: Vec2i, target_pos: Vec2i) {
	source_material := get_cell(grid, source_pos)^
	if next_cell := get_cell(grid, target_pos); next_cell^ < source_material {
		set_cell(grid, source_pos, next_cell^)
		next_cell^ = source_material
	}
}
