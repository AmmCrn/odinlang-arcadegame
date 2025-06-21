package main

import rl "vendor:raylib"
import "core:fmt"

// TODO: what if .HIT is just an array of indices?
// we don't need to store and move all the enemy data ffs

// constants
BULLET_WIDTH :: 3
BULLET_HEIGHT :: 8
ENEMY_SIZE :: 16
ENEMY_W: [ENEMY_TYPE]f32 = {
    .BASIC = 16
}
ENEMY_H: [ENEMY_TYPE]f32 = {
    .BASIC = 16
}

// enums
ENEMY_TYPE :: enum {
    BASIC
}
MOV_TYPES :: enum {
    SWIRL,
    ZIGZAG,
    FLOAT,
    LINE
}
ENEMY_STATE :: enum {
    ALIVE,
    HIT,
    AGGRO
}
// structs
EnemyArr :: struct {
    pos: [32]rl.Vector2,
    hp:  [32]i8,
    mov: [32]MOV_TYPES,
    sprite: ^(rl.Texture2D),
    last: u8
}

enemies : [ENEMY_STATE][ENEMY_TYPE]EnemyArr
// enums

// globals
spr_arr : [GAME_TEXTURE]rl.Texture2D
bullet_arr: [32]rl.Vector2
bullet_n: i8 = 0
enemy_bullet_arr: [256]rl.Vector2
enemy_bullet_n: i8 = 0
input_dir: i8 = 0

// procs
game_update :: proc(dt: f32) {
    // move player
    input_dir = 0
    if rl.IsKeyDown(.A) { input_dir -= 1 }
    if rl.IsKeyDown(.D) { input_dir += 1 }
    
    target_vel := rl.Vector2{f32(input_dir) * PLAYER_MAX_SPEED,0}

    if input_dir != 0 {
        player_vel = rl.Vector2MoveTowards(player_vel, target_vel, dt*PLAYER_ACC)
    } else {
        player_vel = rl.Vector2MoveTowards(player_vel, rl.Vector2{0,0}, PLAYER_SLOWDOWN*dt)
    }
    player_pos.x = clamp(player_pos.x+player_vel.x*dt,0,SCREEN_SIZE)

    // player shoot
    if rl.IsKeyPressed(.LEFT_CONTROL) {
        shoot()
    }

    update_bullets()

    // move enemies
    for &eType in enemies[.ALIVE] {
        for i in 0 ..< int(eType.last) {
            fmt.println(i)
            //eType.pos[i].y += 90.0 / 60.0
            if eType.hp[i] <= 0 || eType.pos[i].y > SCREEN_SIZE {
                kill_enemy(&eType, i)
            }
        }
    }
}

game_draw :: proc(dt: f32){
    draw_bullets()
    draw_enemies()
}

// enemies
spawn_enemy :: proc(pos: rl.Vector2 = {SCREEN_SIZE/2-8, 0}, type: ENEMY_TYPE = .BASIC, mov: MOV_TYPES = .LINE) {
    category := &enemies[.ALIVE][type]
    if category.last > 31 {
        fmt.println("WARNING: could not spawn enemy since array is full")
        return
    }

    category.pos[category.last] = pos
    category.hp[category.last] = 3+i8(type)*2
    category.mov[category.last] = mov

    category.last += 1
}
kill_enemy :: proc(e: ^EnemyArr, i: int) {
    // TODO: relevant death logic, i.e. score, level counter, w/e
    e.pos[i] = e.pos[e.last];
    e.hp[i] = e.hp[e.last]
    e.mov[i] = e.mov[e.last]
    e.last -= 1
}
hit_enemy :: proc(e: ^EnemyArr, typ: ENEMY_TYPE, i: int) {
    // remove hp by one, do NOT check for death, that is in update func
    category := &enemies[.HIT][typ]
    last := category.last
    if category.last > 31 {
        // this is literally impossible to happen but it's good to be sure i guess?
        fmt.println("ERROR: Cannot hit enemy as hit buffer is full")
        return
    }

    // move to .HIT SoA
    category.hp[last] = e.hp[i]
    category.pos[last] = e.pos[i]
    category.mov[last] = e.mov[i]
    category.last += 1

    // remove from .ALIVE

}

draw_enemies :: proc() {
    // TODO
}

// bullets
update_bullets :: proc() {
    for i:i8=0; i < bullet_n ; i += 1 {
        bullet_arr[i].y -= 240 / 60
        if bullet_arr[i].y <= 0 {
           bullet_arr[i] = bullet_arr[bullet_n-1]
            i -= 1; bullet_n -= 1
            continue
        }
        e_loop: for &e, typ in enemies[.ALIVE] {
            for pos, ei in e.pos {
                if rl.CheckCollisionRecs(
                    rl.Rectangle{bullet_arr[i].x, bullet_arr[i].y, BULLET_WIDTH, BULLET_HEIGHT},
                    rl.Rectangle{pos.x, pos.y, ENEMY_W[typ], ENEMY_H[typ]}
                ) {
                    hit_enemy(&e, typ, ei)
                    bullet_arr[i] = bullet_arr[bullet_n-1]
                    i -= 1; bullet_n -= 1
                    break e_loop
                }
            }
        }
    }
}

draw_bullets :: proc() {
    for i:i8=0; i < bullet_n; i+=1 {
        rl.DrawRectangle(i32(bullet_arr[i].x), i32(bullet_arr[i].y), BULLET_WIDTH, BULLET_HEIGHT, rl.WHITE)
    }
}