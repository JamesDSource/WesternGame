import collisions.Collisions;
import collisions.CollisionRay;
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

    public var pushRay: CollisionPolygon;
    
    public function new(screen: Screen) {
        super(screen);

        var tile = Res.Player_png.toTile();
        sprite = new Bitmap(tile);
        sprite.x = x - tile.width/2;
        sprite.y = y - tile.height;
        addChild(sprite);

        var pushRayHeight: Float = 20;
        var colShapeHeight: Float = tile.height - pushRayHeight;
        var colShapeWidth: Float = 20;

        // * Collision polygon
        var colPoly: CollisionPolygon = new CollisionPolygon(x, y);
        var verts: Array<Vector2> = [];
        verts.push(new Vector2(-colShapeWidth/2, -tile.height));
        verts.push(new Vector2(colShapeWidth/2 - 1, -tile.height));
        verts.push(new Vector2(colShapeWidth/2 - 1, -tile.height + colShapeHeight));
        verts.push(new Vector2(-colShapeWidth/2,  -tile.height + colShapeHeight));
        
        colPoly.setVerticies(verts);
        colShape = colPoly;
        addChild(colShape);
        //screen.collisionShapes.push(colShape);

        // * Push ray
        pushRay = new CollisionPolygon(x, y - colShapeHeight);
        pushRay.setVerticies([new Vector2(), new Vector2(0, colShapeHeight-1)]);
        addChild(pushRay);
        pushRay.represent();
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
        if(Key.isPressed(Key.W) && isCollisionAt(pushRay, new Vector2(x, y + 1), screen.collisionShapes)) {
            velocity.y = -8;
        }
        
        velocity = velocity.multF(delta);
        velocity = moveAndCollide(velocity);

        var pushVector = getPushVector(pushRay, new Vector2(0, -1), screen.collisionShapes);
        moveAndCollide(pushVector);
    }
}