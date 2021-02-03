import h3d.Vector;

class Vector2 {
    public var x: Float;
    public var y: Float;

    public function new(x: Float = 0, y: Float = 0) {
        this.x = x;
        this.y = y;
    }

    public function getLength(): Float {
        var squareX = Math.pow(Math.abs(x), 2.0);
        var squareY = Math.pow(Math.abs(y), 2.0);

        return Math.sqrt(squareX + squareY);
    }

    public function normalized(): Vector2 {
        var length = getLength();

        if(length > 0) { // * Keeping the length 0 if it is
            var normX = x/length;
            var normY = y/length;
            return new Vector2(normX, normY);
        }
        else {
            return new Vector2();
        }    
    }

    public function distanceTo(vector2: Vector2): Float {
        var difference = subtract(vector2);
        return difference.getLength();
    }

    // & Vector math functions
    public function add(vector2: Vector2): Vector2 {
        return new Vector2(x + vector2.x, y + vector2.y);
    }

    public function subtract(vector2: Vector2): Vector2 {
        return new Vector2(x - vector2.x, y - vector2.y);
    }

    public function mult(vector2: Vector2): Vector2 {
        return new Vector2(x*vector2.x, y*vector2.y);
    }

    public function div(vector2: Vector2): Vector2 {
        return new Vector2(x/vector2.x, y/vector2.y);
    }


    // & Float math functions
    public function addF(float: Float): Vector2 {
        return new Vector2(x + float, y + float);
    }
    
    public function subtractF(float: Float): Vector2 {
        return new Vector2(x - float, y - float);
    }

    public function multF(float: Float): Vector2 {
        return new Vector2(x*float, y*float);
    }

    public function divF(float: Float): Vector2 {
        return new Vector2(x/float, y/float);
    }
}