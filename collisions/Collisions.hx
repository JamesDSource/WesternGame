package collisions;

class Collisions { // TODO: Add cirle/poly, circle/circle, ray/poly, ray/ray, and ray/circle collisions
    public static function test(shape1: CollisionShape, shape2: CollisionShape): Bool {
        if(Std.isOfType(shape1, CollisionPolygon) && Std.isOfType(shape2, CollisionPolygon)) {
            return polyWithPoly(cast(shape1, CollisionPolygon), cast(shape2, CollisionPolygon));
        }
        else {
            return false;
        }
    }


    // & Checks for a collision between two polygons
    public static function polyWithPoly(polygon1: CollisionPolygon, polygon2: CollisionPolygon): Bool {
        var absPos1 = polygon1.getAbsPosition();
        var absPos2 = polygon2.getAbsPosition();
        if(!radiusIntersection(absPos1, absPos2, polygon1.getRadius(), polygon2.getRadius())) {
            return false;
        }

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

    public static function radiusIntersection(pos1: Vector2, pos2: Vector2, radius1: Float, radius2: Float): Bool {
        var distance = pos1.subtract(pos2).getLength();
        return distance < radius1 + radius2;
    }

    public static function lineIntersection(l1P1: Vector2, l1P2: Vector2, l1Infinite: Bool, l2P1: Vector2, l2P2: Vector2, l2Infinite: Bool): Vector2 {
        // * Calculating standard form of the lines
        var a1 = l1P2.y - l1P1.y,
            b1 = l1P1.x - l1P2.x,
            c1 = a1*l1P1.x + b1*l1P1.y,
            a2 = l2P2.y - l2P1.y,
            b2 = l2P1.x - l2P2.x,
            c2 = a2*l2P1.x + b2*l2P1.y;
        
        // * Using the standard form to find the intersection point
        var denominator = a1*b2 - a2*b1;
        var x = (b2*c1 - b1*c2)/denominator,
            y = (a1*c2 - a2*c1)/denominator;
        if(
            denominator != 0 &&
            ( // * Line one is in range
                l1Infinite ||
                x >= Math.min(l1P1.x, l1P2.x) && x <= Math.max(l1P1.x, l1P2.x) ||   // * X is in range
                y >= Math.min(l1P1.y, l1P2.y) && y <= Math.max(l1P1.x, l1P2.x)      // * Y is in range
            ) &&
            (
                l2Infinite ||
                x >= Math.min(l2P1.x, l2P2.x) && x <= Math.max(l2P1.x, l2P2.x) ||   // * X is in range
                y >= Math.min(l2P1.y, l2P2.y) && y <= Math.max(l2P1.x, l2P2.x)      // * Y is in range
            )
            
        ) {
            return new Vector2(x, y);
        }
        else {
            return null;
        }
    }
}