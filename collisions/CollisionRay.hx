package collisions;

class CollisionRay implements CollisionShape {
    private var shapeName = "Ray";
    public var x: Float;
    public var y: Float;

    private var radius: Float = 0;

    // ^ Cast points are set in local coordinates
    private var castPoint: Vector2 = new Vector2();
    private var castPointTransformed: Vector2 = new Vector2();

    private var scale: Vector2 = new Vector2(1, 1);
    private var rotation: Float = 0;

    public function new(x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function getCastPoint(): Vector2 {
        return castPoint.clone();
    }

    public function getTransformedCastPoint(): Vector2 {
        return castPointTransformed.clone();
    }

    public function getGlobalTransformedCastPoint(): Vector2 {
        return castPointTransformed.add(new Vector2(x, y));
    }

    public function setRotation(degrees: Float) {

    }

    public function testWith(collisionShape: CollisionShape): Bool {
        return false;
    }

    public function setScale(scaleFactor: Vector2) {

    }
}