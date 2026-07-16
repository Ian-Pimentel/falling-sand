package renderer

CELL_SIZE :: 5

material_color: [game.Material]rl.Color = {
	.AIR = rl.BLANK,
	.WATER = rl.BLUE,
    .SAND = rl.YELLOW
};

draw_cell :: proc(cell: game.Cell, position: game.Vec2i) {
	rect := rl.Rectangle {
		f32(position.x * CELL_SIZE),
		f32(position.y * CELL_SIZE),
		CELL_SIZE,
		CELL_SIZE
	}
	
	rl.DrawRectangleRec(rect, material_color[cell.material])
}

draw_brush :: proc(brush_radius: f32) {
	mouse_pos := rl.GetMousePosition()
	
	rl.DrawCircleLines(i32(mouse_pos.x), i32(mouse_pos.y), brush_radius * CELL_SIZE, rl.PINK)
}

draw :: proc(grid: ^game.Grid, brush_radius: f32) {
	// screen_w := rl.GetScreenWidth()
	// screen_h := rl.GetScreenHeight()

	for cell, i in grid {
		position := game.get_position(i)
		draw_cell(cell, position)
	}

	draw_brush(brush_radius)
}

import "../game"
import rl "vendor:raylib"
