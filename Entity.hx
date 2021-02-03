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

    // ^ All entities in the scene. Used mostly for collisions
    public var otherEntites: List<Entity> = new List<Entity>();
    
    // ^ To hold fractions for pixel perfect movement
    private var subPixels: Vector2 = new Vector2();

    public function new(scene: Scene) {
        super();
        scene.addChild(this);
    }

    // & Called every frame. To be overriden by a child.
    public function update(delta: Float) { 
        
    }

    // & Moves in a direction and stops to collide
    public function moveAndCollide(velocity: Vector2, entities: List<Entity>): Vector2 { // Uses collision when I add them in
        // * Adds and stores subpixels
        velocity = velocity.add(subPixels);
        subPixels.x = velocity.x - Math.floor(velocity.x);
        subPixels.y = velocity.y - Math.floor(velocity.y);
        velocity.x = Math.floor(velocity.x);
        velocity.y = Math.floor(velocity.y);
        
        // * X axis collisions
        while(isCollisionAt(new Vector2(x + velocity.x, y), entities)) {
            velocity.x = Math.max(velocity.x - 1, 0);
            if(velocity.x == 0) {
                break;
            }
        }

        setNewPos(new Vector2(x + velocity.x, y));
        
        // * Y axis collisions
        while(isCollisionAt(new Vector2(x, y + velocity.y), entities)) {
            velocity.y = Math.max(velocity.y - 1, 0);
            if(velocity.y == 0) {
                break;
            }
        }

        setNewPos(new Vector2(x, y + velocity.y));
        return velocity;
    }

    public function setNewPos(position: Vector2) {
        subPixels.x += position.x - Math.floor(position.x);
        subPixels.y += position.y - Math.floor(position.y);
        position.x = Math.floor(position.x);
        position.y = Math.floor(position.y);

        setPosition(position.x, position.y);
        colShape.setPosition(position);
    }

    // & Checks collisions with all other entities
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