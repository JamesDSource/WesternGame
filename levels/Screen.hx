package levels;

import ldtk.Layer;
import h2d.Layers;
import h2d.Camera;
import h2d.Scene;
import h2d.Object;
import levels.LDTKLevels;
import levels.LDTKLevels.Entity_Player;

class Screen {
    public var scene: Scene = null;

    public var layers: Layers;
    public var level: LDTKLevels_Level;
    public var entities: Array<Entity> = new Array<Entity>();
    
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

        var collisionRender = level.l_Collisions.render();
        layers.add(collisionRender, 0);

        // * Player
        var players: Array<Entity_Player> = level.l_Entities.all_Player;
        for(player in players) {

        }

    }

    public function update(delta: Float) {

    }
}