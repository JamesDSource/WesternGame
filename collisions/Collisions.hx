package collisions;

class Collisions { // TODO: Add cirle/poly, circle/circle, ray/ray, and ray/circle collisions
    public static function test(shape1: CollisionShape, shape2: CollisionShape): Bool {
        var absPos1 = shape1.getAbsPosition();
        var absPos2 = shape2.getAbsPosition();
        if(!radiusIntersection(absPos1, absPos2, shape1.getRadius(), shape2.getRadius())) {
            return false;
        }

        // * Poly with poly
        if(Std.isOfType(shape1, CollisionPolygon) && Std.isOfType(shape2, CollisionPolygon)) {
            return polyWithPoly(cast(shape1, CollisionPolygon), cast(shape2, CollisionPolygon));
        }
        // * Ray with ray
        else if(Std.isOfType(shape1, CollisionRay) && Std.isOfType(shape2, CollisionRay)) {
            return rayWithRay(cast(shape1, CollisionRay), cast(shape2, CollisionRay)) != null;
        }
        // * Poly with ray
        else if(Std.isOfType(shape1, CollisionPolygon) && Std.isOfType(shape2, CollisionRay)) {
            return polyWithRay(cast(shape1, CollisionPolygon), cast(shape2, CollisionRay)) != null;
        }
        // * Ray with poly
        else if(Std.isOfType(shape1, CollisionRay) && Std.isOfType(shape2, CollisionPolygon)) {
            return polyWithRay(cast(shape2, CollisionPolygon), cast(shape1, CollisionRay)) != null;
        }
        else {
            Sys.println("Unknown collision combination");
            return false;
        }
    }

    // & Tests for an intersection with a ray, and returns the point of collision
    public static function rayTestIntersection(ray: CollisionRay, shape: CollisionShape): Vector2 {
        var absPos1 = ray.getAbsPosition();
        var absPos2 = shape.getAbsPosition();
        if(!radiusIntersection(absPos1, absPos2, ray.getRadius(), shape.getRadius())) {
            return null;
        }

        if(Std.isOfType(shape, CollisionPolygon)) {
            return polyWithRay(cast(shape, CollisionPolygon), ray);
        }
        else if(Std.isOfType(shape, CollisionRay)) {
            return rayWithRay(ray, cast(shape, CollisionRay));
        }
        else {
            return null;
        }
    }


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

    public static function rayWithRay(ray1: CollisionRay, ray2: CollisionRay): Vector2 {
        return lineIntersection(
            ray1.getAbsPosition(), 
            ray1.getGlobalTransformedCastPoint(), 
            ray1.infinite,
            ray2.getAbsPosition(),
            ray2.getGlobalTransformedCastPoint(),
            ray2.infinite
        );
    }

    public static function polyWithRay(poly: CollisionPolygon, ray: CollisionRay): Vector2 {
        var verticies: Array<Vector2> = poly.getGlobalTransformedVerticies();
        var closestIntersection: Vector2 = null;
        var rayPos = ray.getAbsPosition();

        if(pointInPolygon(verticies, rayPos)) {
            return rayPos;
        }

        for(i in 0...verticies.length) {
            var vertex1: Vector2 = verticies[i];
            var vertex2: Vector2 = verticies[(i + 1)%verticies.length];

            var intersection = lineIntersection(vertex1, vertex2, false, ray.getAbsPosition(), ray.getGlobalTransformedCastPoint(), ray.infinite);
            
            if(intersection != null && ( closestIntersection == null || 
            intersection.subtract(rayPos).getLength() < closestIntersection.subtract(rayPos).getLength())) {
                closestIntersection = intersection;
            }
        }
        return closestIntersection;
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
                (x >= Math.min(l1P1.x, l1P2.x) && x <= Math.max(l1P1.x, l1P2.x) &&   // * X is in range
                y >= Math.min(l1P1.y, l1P2.y) && y <= Math.max(l1P1.y, l1P2.y))      // * Y is in range
            ) &&
            (
                l2Infinite ||
                (x >= Math.min(l2P1.x, l2P2.x) && x <= Math.max(l2P1.x, l2P2.x) &&   // * X is in range
                y >= Math.min(l2P1.y, l2P2.y) && y <= Math.max(l2P1.y, l2P2.y))     // * Y is in range
            )
            
        ) {
            return new Vector2(x, y);
        }
        else {
            return null;
        }
    }

    public static function pointInTriangle(a: Vector2, b: Vector2, c: Vector2, point: Vector2): Bool {
        var w1: Float = a.x*(c.y - a.y) + (point.y - a.y)*(c.x - a.x) - point.x*(c.y - a.y);
        w1 /= (b.y - a.y)*(c.x - a.x) - (b.x - a.x)*(c.y - a.y);

        var w2: Float = point.y - a.y - w1*(b.y - a.y);
        w2 /= c.y - a.y;

        return  w1 >= 0 && 
                w2 >= 0 && 
                (w1 + w2) <= 1;
    }

    public static function pointInPolygon(verticies: Array<Vector2>, point: Vector2): Bool {
        if(verticies.length >= 3) {
            var p1: Vector2 = verticies[0];

            for(i in 2...verticies.length) {
                var p2: Vector2 = verticies[i - 1],
                    p3: Vector2 = verticies[i];
                
                if(pointInTriangle(p1, p2, p3, point)) {
                    return true;
                }
            }
        }
        return false;
    }
}