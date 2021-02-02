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

    public function transform(offset: Vector2) {
        base.x += offset.x;
        base.y += offset.y;

        for(vertex in base.vertices) {
            vertex.x += offset.x;
            vertex.y += offset.y;
        }
    }

    public function setPosition(position: Vector2) {
        base.x = position.x;
        base.y = position.y;

        var index: Int = 0;
        for(vertex in base.vertices) {
            vertex.x = position.x + offsets[index].x;
            vertex.y = position.y + offsets[index].y; 
            index++;
        }
    }
}