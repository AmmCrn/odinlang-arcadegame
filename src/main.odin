package main
import rl "vendor:raylib"
import "core:fmt"

SCREEN_SIZE :: 240

main :: proc() {
    // raylib inits
    rl.SetConfigFlags({ .VSYNC_HINT })
    rl.InitWindow(800,800, "Arcade Game")
    rl.SetTargetFPS(60)

    // game inits
    //init_gfx_assets()
    loadok : bool
    sprite_map, loadok = load_sprite_map()
    if !loadok {
        fmt.println("error loading sprite map!")
        return;
    }
    free(&loadok)
    defer delete(sprite_map)
    init_player()
    
    spawn_enemy()
    
    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()
        /* Update Call */
        if rl.IsKeyDown(.A) {
            player.velocity[0] = -64
        } else if rl.IsKeyDown(.D) {
            player.velocity[0] = 64
        } else {
            player.velocity[0] = 0
        }
        player.x += i32(player.velocity[0] * dt) 

        /* Draw Call */
        rl.BeginDrawing()
        rl.ClearBackground({50, 50, 80, 255})

        camera := rl.Camera2D {
            zoom = f32(rl.GetScreenHeight()/SCREEN_SIZE)
        }
        rl.BeginMode2D(camera)

        rl.DrawTexture(player.sprite^, player.x, player.y, rl.WHITE)
        draw_enemies()
        rl.EndMode2D()
        rl.EndDrawing()
    }

    rl.UnloadTexture(player.sprite^);
    rl.CloseWindow()
}

