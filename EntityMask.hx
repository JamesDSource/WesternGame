import differ.shapes.Polygon;
import differ.math.Vector;

class EntityMask {
    public var base:Polygon;
    public var offsets: Array<Vector> = [];

    public function new(base: Polygon) {
        this.base = base;
    }

    public function transform(offset: Vector2) {
        setPosition(new Vector2(base.x + offset.x, base.y + offset.y));
    }

    public function setPosition(position: Vector2) {
        var offset = position.subtract(new Vector2(base.x, base.y));

        base.x += offset.x;
        base.y += offset.y;

        for(vertex in base.vertices) {
            vertex.x += offset.x;
            vertex.y += offset.y; 
        }
    }

}