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
        for(i in 0...collisionLayer.cWid) {
            for(j in 0...collisionLayer.cHei) {
                var hasTile = collisionLayer.hasAnyTileAt(i, j);
                if(hasTile) {
                    var colTile = collisionLayer.getTileStackAt(i, j);
                    var org = new Vector2(i*tileSize, j*tileSize);
                    var verts: Array<Vector2> = [];
                    switch(colTile[0].tileId) {
                        case 0: // Block
                            verts.push(new Vector2());
                            verts.push(new Vector2(tileSize - 1, 0));
                            verts.push(new Vector2(tileSize - 1, tileSize - 1));
                            verts.push(new Vector2(0, tileSize - 1));
                        case 1: // Left facing ramp
                            verts.push(new Vector2(tileSize - 1, 0));
                            verts.push(new Vector2(tileSize - 1, tileSize - 1));
                            verts.push(new Vector2(0, tileSize - 1));
                        case 2: // Rigt facing ramp
                            verts.push(new Vector2());
                            verts.push(new Vector2(tileSize - 1, tileSize - 1));
                            verts.push(new Vector2(0, tileSize - 1));
                    }
                    var staticColShape = new CollisionPolygon(org.x, org.y);
                    staticColShape.setVerticies(verts);
                    layers.add(staticColShape, 2);
                    collisionShapes.push(staticColShape);
                }
            }
        }

        // * Player
        var players: Array<Entity_Player> = level.l_Entities.all_Player;
        for(playerEnt in players) {
            var player = new Player(this);
            player.setNewPos(new Vector2(playerEnt.pixelX, playerEnt.pixelY));

            // * Adding to the scene
            addEntity(player, 1);
            cam.follow = player;
        }

        // * Rifleman
        var riflemen: Array<Entity_Rifleman> = level.l_Entities.all_Rifleman;
        for(rifleman in riflemen) {
            var newRifleman = new Rifleman(this);
            newRifleman.setNewPos(new Vector2(rifleman.pixelX, rifleman.pixelY));

            // * Adding to the scene
            addEntity(newRifleman, 1);
        }

        for(shape in collisionShapes) {
            var newShape = cast(shape, CollisionPolygon);
            newShape.represent();
        }
    }

    public function update(delta: Float) {
        var targetDelta: Float = 1/60;
        var deltaMult = Math.min(delta/targetDelta, 6);
        for(entity in entities) {
            entity.update(deltaMult);
        }
    }

    public function addEntity(entity: Entity, layer: Int) {
        layers.add(entity, layer);
        entities.push(entity); 
    }

    public function removeEntity(entity: Entity) {
        entity.cleanUp();
        entities.remove(entity);
        layers.removeChild(entity);
    }
}