package;

import luxe.Entity;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionCallback;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;

class Board extends Entity {
    public var border : Body;
    private var border_collision_listener : InteractionListener;

    // TODO: implement later.
    private var wallCollisionType : CbType = new CbType();
    /*private var ballCollisionType : CbType = new CbType();*/

    public override function init() {
        create_borders();

        border_collision_listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, wallCollisionType, CbType.ANY_BODY, on_border_collision);
        Luxe.physics.nape.space.listeners.add(border_collision_listener);
    }

    public override function update(dt : Float) {

    }

    private function create_borders() {
        border = new Body(BodyType.STATIC);

        border.shapes.add(new Polygon(Polygon.rect(0, 0, Luxe.screen.w, -1)));
        border.shapes.add(new Polygon(Polygon.rect(0, Luxe.screen.h, Luxe.screen.w, 1)));
        border.shapes.add(new Polygon(Polygon.rect(0, 0, -1, Luxe.screen.h)));
        border.shapes.add(new Polygon(Polygon.rect(Luxe.screen.w, 0, 1, Luxe.screen.h)));
        border.space = Luxe.physics.nape.space;
        border.cbTypes.add(wallCollisionType);

        Main.debug_draw.add(border);
    }

    private function on_border_collision(collision : InteractionCallback) {
        var obj : luxe.Entity = collision.int2.userData.obj;

        trace('on_border_collision: ${obj}');

        obj.destroy();
    }
}