package;

import luxe.Entity;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class Board extends Entity {
    public var border : Body;

    public override function init() {
        border = new Body(BodyType.STATIC);

        border.shapes.add(new Polygon(Polygon.rect(0, 0, Luxe.screen.w, -1)));
        border.shapes.add(new Polygon(Polygon.rect(0, Luxe.screen.h, Luxe.screen.w, 1)));
        border.shapes.add(new Polygon(Polygon.rect(0, 0, -1, Luxe.screen.h)));
        border.shapes.add(new Polygon(Polygon.rect(Luxe.screen.w, 0, 1, Luxe.screen.h)));
        border.space = Luxe.physics.nape.space;

        Main.debug_draw.add(border);
    }

    public override function update(dt : Float) {

    }
}