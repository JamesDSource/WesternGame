class Interpolate {

    // & Interpolates between two floats
    public static function interpolateF(start: Float, ideal:Float, offset: Float): Float {
        if(Math.abs(ideal - start) <= Math.abs(offset)) {
            return ideal;
        }
        else if(start < ideal) {
            return start + Math.abs(offset);
        }
        else {
            return start - Math.abs(offset);
        }
    }

    // & Interpolates between two vectirs
    public static function interpolateVector2(start: Vector2, ideal: Vector2, offset: Float): Vector2 {
        var directionVector: Vector2 = ideal.subtract(start).normalized();
        return new Vector2(interpolateF(start.x, ideal.x, directionVector.x*offset), interpolateF(start.y, ideal.y, directionVector.y*offset));
    }
}