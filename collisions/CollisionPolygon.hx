package collisions;

import h2d.Tile;
import h2d.Bitmap;
import collisions.CollisionShape;

// TODO: Make rotation work
class CollisionPolygon extends CollisionShape {
    // ^ The points that define the polygon
    // * All verticies are relative to the x/y position
    private var verticies: Array<Vector2> = [];
    // ^ The points after scaling and rotation
    private var transformedVerticies: Array<Vector2> = [];

    // ^ Transformation data
    private var polyRotation: Float = 0;

    public function new(x: Float, y: Float) {
        super(x, y);
        shapeName = "Polygon";
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
        syncPos();
        var returnVerticies: Array<Vector2> = getTransformedVerticies();
        for(vert in returnVerticies) {
            vert.x += absX;
            vert.y += absY;
        }
        return returnVerticies;
    }

    public function setPolyRotation(degrees: Float): Void {

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

    public function represent() {
        for(vertex in verticies) {
            var spr = new Bitmap(Tile.fromColor(0x0000FF), this);
            spr.x = vertex.x;
            spr.y = vertex.y;
        }
    }
}