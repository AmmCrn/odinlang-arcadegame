package main

import rl "vendor:raylib"
import "core:fmt"

// constants

// structs

// enums

// globals
enemy_arr: [dynamic]Entity

// procs
game_update :: proc(dt: f32) {
    // move enemies
    for &eny in enemy_arr {
        eny.velocity = rl.Vector2MoveTowards(
            eny.velocity,
            rl.Vector2{0,32},
            4
        )

        eny.x += i32(eny.velocity[0] * dt)
        eny.y += i32(eny.velocity[1] * dt)
    }
}

spawn_enemy :: proc() {
    e :Entity= enemy(SCREEN_SIZE/2, 0, 3)
    append(&enemy_arr, e)
}

draw_enemies :: proc() {
    for e in enemy_arr {
        rl.DrawTexture(e.sprite^, e.x, e.y, rl.WHITE)
    }
}


