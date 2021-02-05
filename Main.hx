import levels.Screen;
import levels.LDTKLevels;

class Main extends hxd.App {

    private var currentLevel: Screen;
    private var levels: LDTKLevels;

    override function init() {
        levels = new LDTKLevels();
        currentLevel = new Screen(levels.all_levels.Test);
        setScene2D(currentLevel.scene, false);
    }

    override function update(delta: Float) {
        currentLevel.update(delta);
    }

    static function main() {
        hxd.Res.initLocal();
        new Main();
    }
}