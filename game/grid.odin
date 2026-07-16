package game

GRID_WIDTH :: 100
GRID_HEIGHT :: 100
GRID_LENGTH :: GRID_WIDTH * GRID_HEIGHT

Cell :: struct {
	material: Material,
	updated: bool
}
Grid :: [GRID_LENGTH]Cell

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

//nn sei se vou usar essas "function unions" mas foi bom saber q existem
get_cell_by_position :: proc(grid: ^Grid, position: Vec2i) -> ^Cell{
	assert(is_position_within_bound(position))
	return &grid[get_index(position)]
}
get_cell_by_index :: proc(grid: ^Grid, index: int) -> ^Cell{
	assert(is_index_valid(index))
	return &grid[index]
}
get_cell :: proc{get_cell_by_position, get_cell_by_index}

set_cell_by_index :: proc(grid: ^Grid, index: int, value: Cell){
	assert(is_index_valid(index))
	grid[index] = value
}
set_cell_by_position :: proc(grid: ^Grid, position: Vec2i, value: Cell) {
	assert(is_position_within_bound(position))
	grid[get_index(position)] = value
}
set_cell_directly :: proc(prev_value: ^Cell, new_value: Cell) {
	prev_value^ = new_value
}
set_cell :: proc{set_cell_directly, set_cell_by_position, set_cell_by_index}

try_set_cell :: proc(grid: ^Grid, position: Vec2i, value: Cell) {
	if !is_position_within_bound(position) do return
	grid[get_index(position)] = value
}

swap_cells :: proc(grid: ^Grid, source_pos: Vec2i, target_pos: Vec2i) {
	source_cell := get_cell(grid, source_pos)
	if next_cell := get_cell(grid, target_pos); next_cell.material < source_cell.material {
		temp := source_cell^
		set_cell(source_cell, next_cell^)
		set_cell(next_cell, temp)
	}
}

//thanks redblobgames!
inside_circle :: proc (center: Vec2i, tile: Vec2i, radius: f32) -> bool{
    dx, dy :=
    center.x - tile.x, center.y - tile.y;
    distance_squared := dx*dx + dy*dy;
    return distance_squared <= int(radius*radius);
}
spawn_circle :: proc(grid: ^Grid, origin: Vec2i, radius: f32, material: Material) {
	cell := Cell{material = material}

	top, bottom, left, right := 
	origin.y - int(math.ceil(radius)),
	origin.y + int(math.floor(radius)),
	origin.x - int(math.ceil(radius)),
	origin.x + int(math.floor(radius))

	for y in top..=bottom {
		for x in left..=right {
			position := Vec2i{x, y}
			if inside_circle(origin, position, radius) {
				try_set_cell(grid, position, cell)
			}
		}
	}
}

import "core:math"
