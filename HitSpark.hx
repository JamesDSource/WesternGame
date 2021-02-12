import hxd.Res;
import h2d.Bitmap;
import h2d.Object;
import levels.Screen;

class HitSpark extends Entity {
    public function new(screen: Screen, x: Float, y:Float) {
        super(screen);
        this.x = x;
        this.y = y;

        var tile = Res.Cursor.toTile();
        tile.dx = -8;
        tile.dy = -8;
        new Bitmap(tile, this);
    }
}