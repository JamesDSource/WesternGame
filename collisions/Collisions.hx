package collisions;

class Collisions { // TODO: Add cirle/poly, circle/circle, ray/poly, ray/ray, and ray/circle collisions
    // & Checks for a collision between two polygons
    public static function polyWithPoly(polygon1: CollisionPolygon, polygon2: CollisionPolygon): Bool {
        var poly1: CollisionPolygon;
        var poly2: CollisionPolygon;

        // * Runs the code twice, switching which role each polygon plays both times
        for(i in 0...2) {
            if(i == 0) {
                poly1 = polygon1;
                poly2 = polygon2;
            }
            else {
                poly1 = polygon2;
                poly2 = polygon1;
            }

            var poly1V = poly1.getGlobalTransformedVerticies();
            var poly2V = poly2.getGlobalTransformedVerticies();
            for(j in 0...poly1V.length) {
                var vert: Vector2 = poly1V[j];
                var nextVert: Vector2 = poly1V[(j + 1)%poly1V.length];
                var axisProj: Vector2 = new Vector2(-(vert.y - nextVert.y), vert.x - nextVert.x);

                // * Projecting each point from both polygons onto
                // * the axis, and seeing if they match up
                var minR1 = Math.POSITIVE_INFINITY;
                var maxR1 = Math.NEGATIVE_INFINITY;
                for(vertex in poly1V) {
                    var dot: Float = vertex.getDotProduct(axisProj);
                    minR1 = Math.min(minR1, dot);
                    maxR1 = Math.max(maxR1, dot);
                } 

                var minR2 = Math.POSITIVE_INFINITY;
                var maxR2 = Math.POSITIVE_INFINITY;
                for(vertex in poly2V) {
                    var dot: Float = vertex.getDotProduct(axisProj);
                    minR2 = Math.min(minR2, dot);
                    maxR2 = Math.max(maxR2, dot);
                }
                
                // * Checking if the shapes overlap
                if(!(maxR2 >= minR1 && maxR1 >= minR2)) {
                    return false;
                }
            }

        }
        return true;
    }

}