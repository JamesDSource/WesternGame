import h3d.shader.ColorAdd;
import h2d.Tile;
import hxd.Res;
import h2d.Graphics;
import differ.math.Vector;
import hxd.Key;
import differ.ShapeDrawer;
import differ.shapes.Polygon;
import h2d.Object;
import h2d.Bitmap;
import h2d.Layers;
import collisions.CollisionPolygon;

class Player extends Entity {
    private var velocity: Vector2 = new Vector2();
    private var speed: Float = 80.0;
    private var acceleration: Float = 10.0;
    public var canMove: Bool = true;

    public var sprite: Bitmap;

    public var vSprite1: Bitmap;
    public var vSprite2: Bitmap;
    public var vSprite3: Bitmap;
    public var vSprite4: Bitmap;
    public var vSprite5: Bitmap;

    public function new(layers: Layers, layer: Int) {
        super(layers, layer);
        var size = 16;
        colShape = new CollisionPolygon(x, y);

        var verts: Array<Vector2> = [];
        verts.push(new Vector2(x-size/2, y-size/2));
        verts.push(new Vector2(x+size/2, y-size/2));
        verts.push(new Vector2(x+size/2, y+size/2));
        verts.push(new Vector2(x-size/2, y+size/2));

        colShape.setVerticies(verts);

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