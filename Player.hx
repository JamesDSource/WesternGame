import h2d.Tile;
import hxd.Res;
import h2d.Graphics;
import hxd.Key;
import h2d.Object;
import h2d.Bitmap;
import h2d.Layers;
import collisions.CollisionPolygon;
import levels.Screen;

class Player extends Entity {
    private var velocity: Vector2 = new Vector2();
    private var speed: Float = 3.0;
    private var acceleration: Float = 0.5;
    public var canMove: Bool = true;

    public var sprite: Bitmap;
    
    public function new(screen: Screen) {
        super(screen);
        var size = 16;
        colShape = new CollisionPolygon(x, y);

        var verts: Array<Vector2> = [];
        verts.push(new Vector2(x-size/2, y-size/2));
        verts.push(new Vector2(x+size/2 - 1, y-size/2));
        verts.push(new Vector2(x+size/2 - 1, y+size/2 - 1));
        verts.push(new Vector2(x-size/2, y+size/2 - 1));

        colShape.setVerticies(verts);
        screen.collisionShapes.push(colShape);

        sprite = new Bitmap(Res.CollisionTile.toTile());
        sprite.x = x - size/2;
        sprite.y = y - size/2;
        addChild(sprite);
    }
    
    override function update(delta: Float) {
        super.update(delta);

        if(canMove) {
            getMovement(delta);
        }
    }

    // & Makes the player move with WASD keys
    private function getMovement(delta: Float) {
        var movementVector = new Vector2();

        if(Key.isDown(Key.A)) {
            movementVector.x -= 1;
        }
        if(Key.isDown(Key.D)) {
            movementVector.x += 1;
        }
        
        movementVector = movementVector.normalized().multF(speed);
        
        velocity.x = Interpolate.interpolateF(velocity.x, movementVector.x, acceleration*delta);
        velocity.y += Constants.GRAVITY*delta;
        
        // * Jump
        if(Key.isPressed(Key.W) && isCollisionAt(new Vector2(x, y + 1), screen.collisionShapes)) {
            velocity.y = -6;
        }
        
        velocity = velocity.multF(delta);
        velocity = moveAndCollide(velocity);
    }
}