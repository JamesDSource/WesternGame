package levels;

import h2d.Graphics;
import collisions.CollisionPolygon;
import ldtk.Tileset;
import ldtk.Layer;
import h2d.Layers;
import h2d.Camera;
import h2d.Scene;
import h2d.Object;
import levels.LDTKLevels;
import levels.LDTKLevels.Entity_Player;
import collisions.CollisionShape;

class Screen {
    public var scene: Scene = null;

    public var layers: Layers;
    public var level: LDTKLevels_Level;

    public var entities: Array<Entity>;

    // ^ All collision shapes in the scene
    // ! Collision shapes that are in use are managed by the entities in the scene. 
    // ! They should be added whenever created, and removed before they are destroyed.
    // ! Otherwise collision detection will check shapes that don't exist anymore, or 
    // ! will not check shapes that are in use
    public var collisionShapes: Array<CollisionShape>;
    
    public var cam: Camera;
    public var camFollow: Object;
    public var camDimensions = new Vector2(960, 540);

    public function new(level: LDTKLevels_Level) {
        this.level = level;
        buildScene();
    }

    // & Initializes the scene, can also be used to reset it
    public function buildScene() {
        // * Resetting the scene
        if(scene != null) {
            scene.dispose();
            scene = null;
        }

        scene = new Scene();
        collisionShapes = [];
        entities = [];
        
        // * Setting up the camera
        cam = scene.camera;
        camFollow = new Object();
        scene.addChild(camFollow);

        cam.follow = camFollow;
        cam.anchorX = 0.5;
        cam.anchorY = 0.5;

        scene.scaleMode = Stretch(Math.floor(camDimensions.x), Math.floor(camDimensions.y));

        // * Setting up layers
        layers = new Layers();
        scene.addChild(layers);

        // * Static collisions
        var collisionLayer = level.l_Collisions;
        var collisionRender = collisionLayer.render();
        layers.add(collisionRender, 0);
        var tileSize = collisionLayer.gridSize;
        for(i in 0...collisionLayer.cHei) {
            var orgPoint: Vector2 = null;
            var colLength = 1;
            for(j in 0...collisionLayer.cWid) {
                var hasTile = collisionLayer.hasAnyTileAt(j, i);
                if(hasTile) {
                    if(orgPoint == null) {
                        orgPoint =  new Vector2(j * tileSize, i * tileSize);
                        colLength = 1;
                    }
                    else {
                        colLength++;
                    }
                }
                if((j >= collisionLayer.cWid - 1 || !hasTile) && orgPoint != null) {
                    var verts: Array<Vector2> = [];

                    verts.push(new Vector2());
                    verts.push(new Vector2(colLength*tileSize - 1, 0));
                    verts.push(new Vector2(colLength*tileSize - 1, tileSize - 1));
                    verts.push(new Vector2(0, tileSize - 1));

                    var staticColPoly = new CollisionPolygon(orgPoint.x, orgPoint.y);
                    staticColPoly.setVerticies(verts);
                    collisionShapes.push(staticColPoly);

                    orgPoint = null;
                    colLength = 1;
                }
            }
        }

        // * Player
        var players: Array<Entity_Player> = level.l_Entities.all_Player;
        for(playerEnt in players) {
            var player = new Player(this);
            player.setNewPos(new Vector2(playerEnt.pixelX, playerEnt.pixelY));

            // * Adding to the scene
            layers.add(player, 1);
            entities.push(player);
            cam.follow = player;
        }

        for(shape in collisionShapes) {
            var newShape = cast(shape, CollisionPolygon);
            for(point in newShape.getGlobalTransformedVerticies()) {
                var spr = new h2d.Bitmap(h2d.Tile.fromColor(0x0000FF), scene);
                spr.x = point.x;
                spr.y = point.y;
            }
        }
    }

    public function update(delta: Float) {
        for(entity in entities) {
            entity.update(delta);
        }
    }
}