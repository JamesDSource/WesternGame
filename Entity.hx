import h2d.Camera;
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

    public function moveAndCollide(velocity: Vector2, entities: List<Entity>): Vector2 { // Uses collision when I add them in
        // X axis collisions
        while(isCollisionAt(new Vector2(x + velocity.x, y), entities)) {
            velocity.x = Math.max(velocity.x - 1, 0);
            if(velocity.x == 0) {
                break;
            }
        }
        
        // Y axis collisions
        while(isCollisionAt(new Vector2(x, y + velocity.y), entities)) {
            velocity.y = Math.max(velocity.y - 1, 0);
            if(velocity.y == 0) {
                break;
            }
        }

        setNewPos(new Vector2(x, y).add(velocity));
        return velocity;
    }

    public function setNewPos(position: Vector2) {
        setPosition(position.x, position.y);
        colShape.setPosition(position);
    }

    public function isCollisionAt(position: Vector2, entities: List<Entity>): Bool {
        colShape.setPosition(position);
        
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

        colShape.setPosition(new Vector2(x, y));
        return isCollision;
    }
}