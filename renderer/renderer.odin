package renderer

CELL_SIZE :: 5

material_color: [game.Material]rl.Color = {
	.AIR = rl.BLANK,
	.WATER = rl.BLUE,
    .SAND = rl.YELLOW
};

draw :: proc(grid: ^game.Grid) {
	screen_w := rl.GetScreenWidth()
	screen_h := rl.GetScreenHeight()

	for cell, i in grid {
		position := game.get_position(i)

		// rl.DrawText(
		// 	"A",
		//  	i32(position.x * CELL_SIZE),
		// 	i32(position.y * CELL_SIZE),
		// 	10,
		// 	material_color[cell]
		// )
		
		rect := rl.Rectangle {
			f32(position.x * CELL_SIZE),
			f32(position.y * CELL_SIZE),
			CELL_SIZE,
			CELL_SIZE
		}
		
		rl.DrawRectangleRec(rect, material_color[cell])
	}

	
}

import "../game"
import rl "vendor:raylib"
