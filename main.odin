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

	for !rl.WindowShouldClose() {
		delta := rl.GetFrameTime()
		tick_acc += delta
		for tick_acc >= TICK_RATE {
			
			game.update()
			
			tick_acc -= TICK_RATE
		}
		
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		renderer.draw()
		rl.EndDrawing()
	}

	fmt.println("Game Over")
}

import "core:fmt"
import rl "vendor:raylib"
import "game"
import "renderer"
