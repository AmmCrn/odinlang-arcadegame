package main
import rl "vendor:raylib"
import "core:fmt"

SCREEN_SIZE :: 250

main :: proc() {
    // raylib inits
    rl.SetConfigFlags({ .VSYNC_HINT })
    rl.InitWindow(800,800, "Arcade Game")
    rl.SetTargetFPS(60)
    defer rl.CloseWindow()

    // game inits
    // try loading in the sprite array
    {
        loadok : bool
        spr_arr, loadok = load_sprite_map()
        if !loadok {
            fmt.println("error loading sprite map!")
            return;
        }
    }

    init_player()
    
    spawn_enemy({16, 16})
    spawn_enemy()
    spawn_enemy({0, 0})
    spawn_enemy({0, 0})
    spawn_enemy({0, 0})
    spawn_enemy({0, 0})
    spawn_enemy({0, 0})
    spawn_enemy({0, 0})
    spawn_enemy({0, 0})

    for !rl.WindowShouldClose() {
        dt := rl.GetFrameTime()
        /* Update Call */
        game_update(dt)
        
        /* Draw Call */
        rl.BeginDrawing()
        rl.ClearBackground({50, 50, 80, 255})

        camera := rl.Camera2D {
            zoom = f32(rl.GetScreenHeight()/SCREEN_SIZE)
        }
        rl.BeginMode2D(camera)

        rl.DrawTextureV(spr_arr[.PLAYER], player_pos, rl.WHITE)
        
        game_draw(dt)
        rl.DrawFPS(0,0)

        rl.EndMode2D()
        rl.EndDrawing()
    }
}

