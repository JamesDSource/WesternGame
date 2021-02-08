import collisions.CollisionShape;
import differ.sat.SAT2D;
import h2d.Layers;
import h2d.Camera;
import h2d.Scene;
import differ.data.ShapeCollision;
import differ.shapes.Polygon;
import collisions.Collisions;
import h2d.Object;
import collisions.CollisionPolygon;
import levels.Screen;

class Entity extends Object {
    public var hitPointsMax: Float = 100;
    public var hitPoints: Float = 100;

    public var colShape: CollisionShape;

    private var screen: Screen;

    public var deltaMult: Float = 0.0;


    // ^ All entities in the scene. Used mostly for collisions
    public var otherEntites: List<Entity> = new List<Entity>();
    
    // ^ To hold fractions for pixel perfect movement
    private var subPixels: Vector2 = new Vector2();

    public function new(screen: Screen) {
        super();
        this.screen = screen;
    }

    // & Called every frame. To be overriden by a child.
    public function update(delta: Float) { 
        deltaMult = delta;
    }

    // & Moves in a direction and stops to collide
    public function moveAndCollide(velocity: Vector2): Vector2 {
        // * Adds and stores subpixels
        velocity = velocity.add(subPixels);
        subPixels.x = velocity.x - Math.floor(velocity.x);
        subPixels.y = velocity.y - Math.floor(velocity.y);
        velocity.x = Math.floor(velocity.x);
        velocity.y = Math.floor(velocity.y);
        
        // * X axis collisions
        while(isCollisionAt(new Vector2(x + velocity.x, y), screen.collisionShapes)) {
            velocity.x = Math.max(velocity.x - 1, 0);
            if(velocity.x == 0) {
                break;
            }
        }
        
        setNewPos(new Vector2(x + velocity.x, y));
        
        // * Y axis collisions
        while(isCollisionAt(new Vector2(x, y + velocity.y), screen.collisionShapes)) {
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
        colShape.syncPos();
    }

    // & Checks collisions with all other entities
    public function isCollisionAt(position: Vector2, shapes: Array<CollisionShape>): Bool {
        if(!colShape.active) {
            return false;
        }
        
        var oldColShapePos: Vector2 = new Vector2(colShape.x, colShape.y);

        colShape.x = position.x - x;
        colShape.y = position.y - y;
        
        var isCollision: Bool = false;
        
        for(shape in shapes) {
            if(shape != colShape && shape.active) {
                var colTest: Bool = Collisions.test(colShape, shape);

                if(colTest) {
                    isCollision = true;
                    break;
                }
            }
        }

        colShape.x = oldColShapePos.x;
        colShape.y = oldColShapePos.y;
        return isCollision;
    }

}