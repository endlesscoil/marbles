package util;

import luxe.Vector;

class Util
{
    public static inline function distance(p1 : Vector, p2 : Vector) : Float
    {   
        return Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2));
    }   
}
