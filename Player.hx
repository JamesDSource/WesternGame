import hxd.Key;
import differ.ShapeDrawer;
import differ.shapes.Polygon;

class Player extends Entity {
    private var speed: Float = 60.0;
    public var canMove: Bool = true;

    public function new(scene: h2d.Scene) {
        super(scene);
        colShape = new EntityMask(Polygon.square(x, y, 100, true));
        colShape.imprint();
    }
    
    override function update(delta: Float) {
        super.update(delta);

        var customGraphics = new h2d.Graphics(getScene());
        customGraphics.beginFill(0xEA8220);
        customGraphics.drawRect(x -25, y - 25, 50, 50);
        customGraphics.endFill();

        if(canMove) {
            if(Key.isDown(Key.W)) {
                moveAndCollide(0, -speed*delta, otherEntites);
            }
            if(Key.isDown(Key.A)) {
                moveAndCollide(-speed*delta, 0, otherEntites);
            }
            if(Key.isDown(Key.S)) {
                moveAndCollide(0, speed*delta, otherEntites);
            }
            if(Key.isDown(Key.D)) {
                moveAndCollide(speed*delta, 0, otherEntites);
            }
        }
    }
}