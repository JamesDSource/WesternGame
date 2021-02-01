import differ.shapes.Polygon;
import differ.math.Vector;

class EntityMask {
    public var base:Polygon;
    public var offsets: Array<Vector> = [];

    public function new(base: Polygon) {
        this.base = base;
    }

    public function imprint() {
        // Gets each vertex pos relative to the x/y
        offsets = [];
        for(vertex in base.vertices) {
            var xOffset: Float = vertex.x - base.x;
            var yOffset: Float = vertex.y - base.y;

            offsets.push(new Vector(xOffset, yOffset));
        }
    }

    public function transform(x: Float, y: Float) {
        base.x += x;
        base.y += y;

        for(vertex in base.vertices) {
            vertex.x += x;
            vertex.y += y;
        }
    }

    public function setPosition(x: Float, y: Float) {
        base.x = x;
        base.y = y;

        var index: Int = 0;
        for(vertex in base.vertices) {
            vertex.x = x + offsets[index].x;
            vertex.y = y + offsets[index].y; 
            index++;
        }
    }
}