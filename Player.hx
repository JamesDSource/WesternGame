import h2d.Graphics;
import differ.math.Vector;
import hxd.Key;
import differ.ShapeDrawer;
import differ.shapes.Polygon;
import h2d.Object;
import h2d.Bitmap;

class Player extends Entity {
    private var velocity: Vector2 = new Vector2();
    private var speed: Float = 80.0;
    private var acceleration: Float = 10.0;
    public var canMove: Bool = true;

    public var sprite: Bitmap;

    public function new(scene: h2d.Scene) {
        super(scene);
        colShape = new EntityMask(Polygon.square(x-50, y-50, 100, true));

        sprite = new Bitmap(h2d.Tile.fromColor(0xFF0000, 50, 50), scene);
    }
    
    override function update(delta: Float) {
        super.update(delta);

        sprite.x = x - 25;
        sprite.y = y - 25;

        if(canMove) {
            getMovement(delta);
        }

    }

    // & Makes the player move with WASD keys
    private function getMovement(delta: Float) {
        var movementVector = new Vector2();

        if(Key.isDown(Key.W)) {
            movementVector.y -= 1;
        }
        if(Key.isDown(Key.A)) {
            movementVector.x -= 1;
        }
        if(Key.isDown(Key.S)) {
            movementVector.y += 1;
        }
        if(Key.isDown(Key.D)) {
            movementVector.x += 1;
        }
        
        movementVector = movementVector.normalized().multF(speed*delta);
        
        velocity = Interpolate.interpolateVector2(velocity, movementVector, acceleration*delta);
        velocity = moveAndCollide(velocity, otherEntites);

    }
    
}