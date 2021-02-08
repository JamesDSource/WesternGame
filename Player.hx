import h3d.pass.Default;
import h2d.Anim;
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

enum PLAYERSTATE {
    FREE;
    DEAD;
}

class Player extends Entity {
    private var velocity: Vector2 = new Vector2();
    private var speed: Float = 3.0;
    private var acceleration: Float = 0.5;
    
    public var state = PLAYERSTATE.FREE;

    // ^ Holds all animations
    public var animations: AnimationPlayer;

    public var pushRay: CollisionPolygon;
    
    public function new(screen: Screen) {
        super(screen);

        // * Animations
        animations = new AnimationPlayer();
        addChild(animations);
        animations.addAnimation(
            "Lower still",
            Res.PlayerLowerStill.toTile(),
            1,
            AnimationPlayer.Origin.bottomCenter
        );
        animations.addAnimation(
            "Upper idle",
            Res.PlayerUpperIdle.toTile(),
            3,
            AnimationPlayer.Origin.bottomCenter
        );
        animations.animations["Upper idle"].speed = 3;

        var pushRayHeight: Float = 20;
        var colShapeHeight: Float = 42 - pushRayHeight;
        var colShapeWidth: Float = 20;

        // * Collision polygon
        var colPoly: CollisionPolygon = new CollisionPolygon(x, y);
        var verts: Array<Vector2> = [];
        verts.push(new Vector2(-colShapeWidth/2, -42));
        verts.push(new Vector2(colShapeWidth/2 - 1, -42));
        verts.push(new Vector2(colShapeWidth/2 - 1, -42 + colShapeHeight));
        verts.push(new Vector2(-colShapeWidth/2,  -42 + colShapeHeight));
        
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

        switch(state) {
            case PLAYERSTATE.FREE:
                getMovement(delta);
                
            case PLAYERSTATE.DEAD:
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
        
        if(movementVector.x != 0) { // TODO: Move to a seperate function that handles all animations
            animations.setFlipped(movementVector.x < 0);
        }

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