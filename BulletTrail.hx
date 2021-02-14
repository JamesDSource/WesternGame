import hxd.Res;
import h2d.Object;
import h2d.Tile;
import h2d.Bitmap;

import levels.Screen;

class BulletTrail extends Entity {
    public var a: Float = 1.0;

    // ^ goTo is a local transformation from the x/y position
    private var goTo: Vector2;

    public function new(screen: Screen, x: Float, y: Float, goTo: Vector2) {
        super(screen);

        this.x = x;
        this.y = y;
        this.goTo = goTo;
        var tile = Res.BulletTrail.toTile();
        tile.dy = -1;
        tile.scaleToSize(goTo.getLength(), 2);
        new Bitmap(tile, this);

        rotation = goTo.getAngle();
    }

    public override function update(delta: Float) {
        super.update(delta);
        
        // TODO: Create a shader that smooths the alpha starting from the start of the trail
        // TODO: instead of just adjusting the entire alpha
        alpha = Interpolate.interpolateF(alpha, 0, 0.1);
        if(alpha <= 0) {
            screen.removeEntity(this);
        }
    }
}