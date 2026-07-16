package main

WINDOW_WIDTH :: 600
WINDOW_HEIGHT :: 600
WINDOW_TITLE :: "Falling Sand"
TARGET_FPS :: 60

TICK_RATE :: 1.0 / 60

mouse_pos_to_coords :: proc() -> rl.Vector2 {
	mouse_pos := rl.GetMousePosition() 
	mouse_pos /= renderer.CELL_SIZE
	return mouse_pos
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	defer rl.CloseWindow()
	rl.SetTargetFPS(TARGET_FPS)

	tick_acc: f32 = 0.0
	brush_radius: f32 = 1.0

	grid: game.Grid 
	for !rl.WindowShouldClose() {
		num_sand := 0
		num_water := 0
		delta := rl.GetFrameTime()
		tick_acc += delta

		for tick_acc >= TICK_RATE {
			brush_radius = math.max(1, math.min(brush_radius + rl.GetMouseWheelMove(), 20))

			if rl.IsMouseButtonDown(.LEFT) {
				coords := mouse_pos_to_coords()
				game.spawn_circle(&grid, {int(coords.x), int(coords.y)}, brush_radius, game.Material.SAND)
			}
			if rl.IsMouseButtonDown(.RIGHT) {
				coords := mouse_pos_to_coords()
				game.spawn_circle(&grid, {int(coords.x), int(coords.y)}, brush_radius, game.Material.WATER)
			}
			
			if rl.IsKeyPressed(.R) {
				game.init_grid(&grid)
			}
			
			game.update(&grid)
			
			tick_acc -= TICK_RATE

			for cell in grid {
				if cell.material == .SAND do num_sand += 1
				else if cell.material == .WATER do num_water += 1
			}
		}
		
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		renderer.draw(&grid, brush_radius)
		rl.DrawText(fmt.ctprintfln("num of sand => %i\nnum of water => %i", num_sand, num_water), 0,0,10,rl.WHITE)
		rl.DrawText(fmt.ctprintfln("mouse_wheel %f", brush_radius), 0,20,20,rl.WHITE)
		rl.EndDrawing()

		free_all(context.temp_allocator)
	}

	fmt.println("Game Over")
}

import "core:math"
import "core:fmt"
import rl "vendor:raylib"
import "game"
import "renderer"
