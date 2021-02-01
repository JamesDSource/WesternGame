import h2d.Scene;
import differ.data.ShapeCollision;
import differ.shapes.Polygon;
import differ.Collision;
import h2d.Object;

class Entity extends Object {
    public var hitPointsMax: Float = 100;
    public var hitPoints: Float = 100;

    public var colShape: EntityMask;

    public var otherEntites: List<Entity> = new List<Entity>();
    
    public function new(scene: Scene) {
        super();
        scene.addChild(this);
    }

    public function update(delta: Float) { // Called every frame, to be overriden
        
    }

    public function moveAndCollide(moveX: Float, moveY: Float, entities: List<Entity>) { // Uses collision when I add them in
        colShape.transform(moveX, moveY);

        var isCollision: Bool = false;
        for(entity in entities) {
            if(entity != this) {
                var shape: Polygon = entity.colShape.base;
                var colTest = colShape.base.test(shape);

                if(colTest != null) {
                    isCollision = true;
                }
            }
        }

        if(isCollision) {
            colShape.setPosition(x, y);
        }
        else {
            setPosition(colShape.base.x, colShape.base.y);
        }
    }

    public function setNewPos(newX: Float, newY: Float) {
        setPosition(newX, newY);
        colShape.setPosition(newX, newY);
    }
}