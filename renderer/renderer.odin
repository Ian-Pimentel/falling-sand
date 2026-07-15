package renderer

draw :: proc() {
	rl.DrawText("Hello World!", 0, 0, 20, rl.WHITE)
}

import rl "vendor:raylib"
