package collisions;

import Vector2;
import h2d.Object;

class CollisionShape extends Object {
    public var active: Bool = true;
    private var radius: Float = 0;

    public var tags: Array<String> = [];
    public var ignoreTags: Array<String> = [];

    public function new(x: Float, y: Float) {
        super();
        this.x = x;
        this.y = y;
    }

    public function getAbsPosition(): Vector2 {
        syncPos();
        return new Vector2(absX, absY);
    }

    public function getRadius(): Float {
        return radius;
    }

    public function canInteractWith(shape: CollisionShape): Bool {
        for(tag in shape.tags) {
            if(ignoreTags.contains(tag)) {
                return false;
            }
        }
        return true;
    }
}