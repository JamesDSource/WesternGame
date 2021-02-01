import differ.shapes.Polygon;
import h2d.Graphics;

class Main extends hxd.App {
    public var entities: List<Entity> = new List<Entity>();
    public var player: Player;
    public var player2: Player;

    override function init() {
        player = new Player(s2d);
        player2 = new Player(s2d);
        entities.add(player);
        entities.add(player2);
        player.name = "Player one";
        player2.name = "Player two";
        player2.canMove = false;
        player2.setNewPos(300, 300);
    }

    override function update(delta: Float) {
        var graphics = new h2d.Graphics(s2d);
        graphics.beginFill(0x000000);
        graphics.drawRect(0, 0, 1000, 1000);
        graphics.endFill();

        // Entity update event
        for(entity in entities) {
            entity.otherEntites = entities;
            entity.update(delta);
        }
    }

    static function main() {
        new Main();
    }
}