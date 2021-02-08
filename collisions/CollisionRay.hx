package collisions;

class CollisionRay extends CollisionShape {
    // ^ Cast points are set in local coordinates
    private var castPoint: Vector2 = new Vector2();
    private var castPointTransformed: Vector2 = new Vector2();
    public var infinite: Bool = false;

    private var rayScale: Vector2 = new Vector2(1, 1);

    public function new(x: Float, y: Float, infinite: Bool = false) {
        super(x, y);
        this.infinite = infinite;
        shapeName = "Ray";        
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

    public function setCastPoint(point: Vector2) {
        castPoint = point;
        calculateTransformations();
    }

    // && Sets 'castPointTransformed' to 'castPoint' rotated and scaled
    private function calculateTransformations() {
        castPointTransformed = castPoint;
        castPointTransformed = castPointTransformed.mult(rayScale);
    }

    public function setRayScale(scaleFactor: Vector2) {
        rayScale = scaleFactor;
        calculateTransformations();
    }
}