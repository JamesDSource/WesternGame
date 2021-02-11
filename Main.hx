import hxd.Res;
import levels.Screen;
import levels.LDTKLevels;
import hxd.Cursor;
import hxd.System;

class Main extends hxd.App {

    private var currentLevel: Screen;
    private var levels: LDTKLevels;
    private var customCursor: CustomCursor;

    override function init() {
        levels = new LDTKLevels();
        currentLevel = new Screen(levels.all_levels.Test);
        setScene2D(currentLevel.scene, false);

        customCursor = new CustomCursor([Res.Cursor.toBitmap()], 0, 8, 8);
    }

    override function update(delta: Float) {
        currentLevel.update(delta);
        System.setNativeCursor(Cursor.Custom(customCursor));
    }

    static function main() {
        hxd.Res.initLocal();
        new Main();
    }
}