package collisions;

import Vector2;

interface CollisionShape {
    private var shapeName: String;
    public var x: Float;
    public var y: Float;
    private var radius: Float;
    public function setRotation(degrees: Float): Void;
    public function testWith(collisionShape: CollisionShape): Bool;
}