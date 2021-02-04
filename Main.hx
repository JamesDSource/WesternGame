import quadtree.QuadTree;
import h2d.Layers;
import h2d.Camera;
import differ.shapes.Polygon;
import h2d.Graphics;
import h2d.Object;
import ldtk.Project;
import levels.LDTKLevels;

class Main extends hxd.App {
    public var entities: List<Entity> = new List<Entity>();
    
    public var cam: Camera;
    public var camFollow: Object;
    
    public var player: Player;
    public var player2: Player;

    override function init() {

        var layers = new Layers();
        s2d.addChild(layers);

        var levels = new LDTKLevels();
        var render = levels.all_levels.Test.l_Collisions.render();
        layers.add(render, 0);

        cam = s2d.camera;
        camFollow = new Object();
        s2d.addChild(camFollow);

        cam.follow = camFollow;
        cam.anchorX = 0.5;
        cam.anchorY = 0.5;

        s2d.scaleMode = Stretch(960, 540);

        player = new Player(s2d, 1);
        player2 = new Player(layers, 1);
        entities.add(player);
        entities.add(player2);
        player.name = "Player one";
        player2.name = "Player two";
        player2.canMove = false;
        player2.setNewPos(new Vector2(200, 200));
    }

    override function update(delta: Float) {

        // Entity update event
        for(entity in entities) {
            entity.otherEntites = entities;
            entity.update(delta);
        }

        // TODO: Move camera code to a level class and expand parameters
        camFollow.x = player.x + 25;
        camFollow.y = player.y + 25;
    }

    static function main() {
        hxd.Res.initLocal();
        new Main();
    }
}