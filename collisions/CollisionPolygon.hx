package collisions;

import collisions.CollisionShape;

// TODO: Make scaling and rotation work
class CollisionPolygon implements CollisionShape {
    private var shapeName = "Polygon";

    public var x: Float;
    public var y: Float;
    
    public var active: Bool = true;

    private var radius: Float;

    // ^ The points that define the polygon
    // * All verticies are relative to the x/y position
    private var verticies: Array<Vector2> = [];
    // ^ The points after scaling and rotation
    private var transformedVerticies: Array<Vector2> = [];

    // ^ Transformation data
    private var scale: Vector2 = new Vector2(1.0, 1.0);

    public function new(x: Float, y: Float) {
        this.x = x;
        this.y = y;
    }

    public function getVerticies(): Array<Vector2> {
        var returnVerticies: Array<Vector2> = [];
        for(vertex in verticies) {
            returnVerticies.push(vertex.clone());
        }
        return returnVerticies;
    }

    public function getTransformedVerticies(): Array<Vector2> {
        var returnVerticies: Array<Vector2> = [];
        for(vertex in transformedVerticies) {
            returnVerticies.push(vertex.clone());
        }
        return returnVerticies;
    }

    public function getGlobalTransformedVerticies(): Array<Vector2> {
        var returnVerticies: Array<Vector2> = getTransformedVerticies();
        for(vert in returnVerticies) {
            vert.x += x;
            vert.y += y;
        }
        return returnVerticies;
    }

    public function getRadius(): Float {
        return radius;
    }

    public function setRotation(degrees: Float): Void {

    }

    public function setScale(scaleFactor: Vector2) {
        for(vertex in verticies) {
            vertex = vertex.mult(scaleFactor);
        }

        radius *= Math.max(scaleFactor.x, scaleFactor.y);
    }

    public function setVerticies(verticies: Array<Vector2>) {
        this.verticies = verticies;
        transformedVerticies = verticies;

        radius = 0.0;
        for(vertex in this.verticies) {
            var len: Float = vertex.getLength();
            
            if(len > radius) {
                radius = Math.ceil(len);
            }

        }
    }
}