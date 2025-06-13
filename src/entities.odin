package main
import rl "vendor:raylib"
import "core:fmt"
import "core:os"
import "core:strings"

// constants
PLAYER_SIZE :: 16
PLAYER_X :: (SCREEN_SIZE - PLAYER_SIZE) / 2
PLAYER_Y :: SCREEN_SIZE 
PLAYER_HP :: 3

// structs
Entity :: struct {
    // is it worth downsizing this to an i8 or i16?
    // it would require casting literally everywhere
    x, y, w, h, hp: i32,
    velocity: rl.Vector2,
    sprite: ^(rl.Texture2D),
}

// globals
sprite_map := make(map[string]rl.Texture2D)
player: Entity

// procs
init_gfx_assets :: proc() {
    GFX_PATH :: "gfx/"

    dir_handle, open_err := os.open(GFX_PATH)
    if open_err != nil {
        fmt.println("Failed to open gfx directory! err:", open_err)
        return
    }

    entries, read_err := os.read_dir(dir_handle, 100)
    if read_err != nil {
        fmt.println("Failed to read gfx directory! err:", read_err)
        return
    }

    for entry in entries {
        if(strings.has_suffix(entry.name, ".png")){
            // if png file add it to the sprite map
            imgpath, _ := strings.concatenate({GFX_PATH, entry.name})
            cimgpath := strings.clone_to_cstring(imgpath)
            sprite_name := entry.name[:len(entry.name)-4]

            sprite_map[strings.clone(sprite_name)] = rl.LoadTexture(cimgpath)
            if sprite_map[sprite_name].id == 0 {
                rl.TraceLog(rl.TraceLogLevel.ALL, "Failed to load sprite");
                rl.CloseWindow();
                return;
            }
        }
        

        os.file_info_delete(entry)
    }

    os.close(dir_handle)
}
init_player :: proc() {
    player.x, player.y = PLAYER_X, PLAYER_Y
    player.w, player.h = PLAYER_SIZE, PLAYER_SIZE
    player.hp = PLAYER_HP
    player.velocity = rl.Vector2{0,0}
    player.sprite = &(sprite_map["player"])

    if player.sprite.id == 0 {
        rl.TraceLog(rl.TraceLogLevel.ALL, "Failed to load player sprite");
        rl.CloseWindow();
        return;
    }
}

enemy :: proc(x, y, hp: i32) -> Entity {
    e: Entity
    e.x = x; e.y = y; e.hp = hp
    e.velocity = rl.Vector2{0,0}
    e.sprite = &(sprite_map["enemy_basic"])
    return e
}