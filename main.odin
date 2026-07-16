package main

WINDOW_WIDTH :: 600
WINDOW_HEIGHT :: 600
WINDOW_TITLE :: "Falling Sand"
TARGET_FPS :: 60

TICK_RATE :: 1.0 / 60

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	defer rl.CloseWindow()
	rl.SetTargetFPS(TARGET_FPS)

	tick_acc: f32 = 0.0

	grid: game.Grid 
	// game.set_cell(&grid, {game.GRID_WIDTH / 2, /* game.GRID_HEIGHT / 2 */0}, .SAND)
	for !rl.WindowShouldClose() {
		num_sand := 0
		num_water := 0
		delta := rl.GetFrameTime()
		tick_acc += delta

		for tick_acc >= TICK_RATE {
			if rl.IsMouseButtonDown(.LEFT) {
				mouse_pos := rl.GetMousePosition() 
				mouse_pos /= renderer.CELL_SIZE
				game.try_set_cell(&grid, {int(mouse_pos.x), int(mouse_pos.y)}, .SAND)
			}
			if rl.IsMouseButtonDown(.RIGHT) {
				mouse_pos := rl.GetMousePosition() 
				mouse_pos /= renderer.CELL_SIZE
				game.try_set_cell(&grid, {int(mouse_pos.x), int(mouse_pos.y)}, .WATER)
			}
			if rl.IsKeyPressed(.R) {
				game.init_grid(&grid)
			}
			
			game.update(&grid)
			
			tick_acc -= TICK_RATE

			for cell in grid {
				if cell == .SAND do num_sand += 1
				else if cell == .WATER do num_water += 1
			}
		}
		
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		renderer.draw(&grid)
		rl.DrawText(fmt.ctprintfln("num of sand => %i\nnum of water => %i", num_sand, num_water), 0,0,10,rl.WHITE)
		rl.EndDrawing()

		free_all(context.temp_allocator)
	}

	fmt.println("Game Over")
}

import "core:fmt"
import rl "vendor:raylib"
import "game"
import "renderer"
