package main

import rl "vendor:raylib"
import "core:fmt"

// const
PLAYER_SIZE :: 16
PLAYER_X :: (SCREEN_SIZE - PLAYER_SIZE) / 2
PLAYER_Y :: SCREEN_SIZE -8
PLAYER_HP :: 3
PLAYER_MAX_SPEED :: 128
PLAYER_ACC :: 1024
PLAYER_SLOWDOWN :: 800

// globals
player_pos : rl.Vector2
player_vel : rl.Vector2
player_hp : i8
player_dir := 1

// proc
init_player :: proc() {
    player_pos.x, player_pos.y = PLAYER_X, PLAYER_Y
    player_hp = PLAYER_HP
    player_vel = rl.Vector2{0,0}
}

shoot :: proc() {
    if bullet_n == 32 {
        fmt.println("WARNING: Trying to shoot more bullets than capable of storing.")
        return
    }
    bullet_arr[bullet_n] = rl.Vector2{player_pos.x+PLAYER_SIZE/2, player_pos.y-BULLET_HEIGHT-2}
    bullet_n += 1
}