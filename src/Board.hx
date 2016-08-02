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
    public var marbles : Array<Marble> = new Array<Marble>();

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

        var pax = Constants.PLAYABLE_X_OFFSETS;
        var pay = Constants.PLAYABLE_Y_OFFSETS;

        border.shapes.add(new Polygon(Polygon.rect(pax[0], pay[0], Luxe.screen.w + pax[1], -1)));
        border.shapes.add(new Polygon(Polygon.rect(pax[0], Luxe.screen.h + pay[1], Luxe.screen.w + pax[1], 1)));
        border.shapes.add(new Polygon(Polygon.rect(pax[0], pay[0], -1, Luxe.screen.h + pay[1])));
        border.shapes.add(new Polygon(Polygon.rect(Luxe.screen.w + pax[1], pay[0], 1, Luxe.screen.h + pay[1])));

        border.space = Luxe.physics.nape.space;
        border.cbTypes.add(wallCollisionType);

        Main.debug_draw.add(border);
    }

    private function on_border_collision(collision : InteractionCallback) {
        var obj : luxe.Entity = collision.int2.userData.obj;

        trace('on_border_collision: ${obj}');

        if (obj.get('shooter') == null) {
            obj.destroy();
            Luxe.events.fire('border_collision');
        }
    }
}