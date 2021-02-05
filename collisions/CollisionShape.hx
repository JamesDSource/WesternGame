package collisions;

import Vector2;

interface CollisionShape {
    private var shapeName: String;
    public var active: Bool;
    public var x: Float;
    public var y: Float;
    private var radius: Float;
    public function testWith(collisionShape: CollisionShape): Bool;
}