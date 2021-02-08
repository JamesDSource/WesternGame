package collisions;

import Vector2;
import h2d.Object;

class CollisionShape extends Object {
    public var shapeName: String = "Default Shape";
    public var active: Bool = true;
    private var radius: Float = 0;

    public function new(x: Float, y: Float) {
        super();
        this.x = x;
        this.y = y;
    }

    public function getAbsPosition(): Vector2 {
        syncPos();
        return new Vector2(absX, absY);
    }
}