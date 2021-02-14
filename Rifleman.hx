import collisions.CollisionRay;
import hxd.Res;
import collisions.CollisionPolygon;
import levels.Screen;

enum RiflemanState {
    Roam;
    Shoot;
    Dead;
}

class Rifleman extends Entity {
    private var state = RiflemanState.Roam;
    
    private var velocity: Vector2 = new Vector2();
    private var moveDirection: Float = 1.0;
    private var moveSpeed: Float = 1.0;
    private var acceleration: Float = 0.1; 

    private var animationPlayer: AnimationPlayer = new AnimationPlayer();

    private var pushRay: CollisionRay;
    private var hitbox: CollisionPolygon;

    public function new(screen: Screen) {
        super(screen);

        // * Sprite
        var tile = Res.RiflemanPlaceholder.toTile();
        animationPlayer.addAnimation("placeholder", tile, 1, AnimationPlayer.Origin.bottomCenter);

        addChild(animationPlayer);

        // * Collision shape
        var colPoly = new CollisionPolygon(x, y);

        var colShapeSize = new Vector2(18, 16);
        var verts: Array<Vector2> = [
            new Vector2(-colShapeSize.x/2, -colShapeSize.y - 16),
            new Vector2(colShapeSize.x/2 - 1, -colShapeSize.y - 16),
            new Vector2(colShapeSize.x/2 - 1, -17),
            new Vector2(-colShapeSize.x/2, -17)
        ];
        colPoly.setVerticies(verts);

        colShape = colPoly;
        colShape.ignoreTags.push("hitbox");
        addChild(colShape);

        // * Push ray
        pushRay = new CollisionRay(x, y - 16);
        pushRay.setCastPoint(new Vector2(0, 15));
        pushRay.ignoreTags.push("hitbox");
        addChild(pushRay);

        // * Hitbox
        var hitbox = new CollisionPolygon(x, y);

        var hitboxSize = new Vector2(18, 32);
        var verts: Array<Vector2> = [
            new Vector2(-hitboxSize.x/2, -hitboxSize.y),
            new Vector2(hitboxSize.x/2 - 1, -hitboxSize.y),
            new Vector2(hitboxSize.x/2 - 1, -1),
            new Vector2(-hitboxSize.x/2, -1)
        ];
        hitbox.setVerticies(verts);
        addChild(hitbox);
        screen.collisionShapes.push(hitbox);
        hitbox.tags.push("hitbox");

    }

    public override function update(delta: Float) {
        super.update(delta);

        switch(state) {
            case RiflemanState.Roam:
                velocity.x = Interpolate.interpolateF(velocity.x, moveDirection*moveSpeed, acceleration);
                velocity.y += Constants.GRAVITY;
                velocity = moveAndCollide(velocity);

                var pushVector = getPushVector(pushRay, new Vector2(0, -1), screen.collisionShapes);
                moveAndCollide(pushVector);

                if(isCollisionAt(colShape, new Vector2(x + moveDirection, y), screen.collisionShapes)) {
                    moveDirection *= -1;
                }
            case RiflemanState.Shoot:
            case RiflemanState.Dead:
            default:
                trace("Unidentified state");
        }
    }
}