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
    private var circle_sensor_listener : InteractionListener;

    // TODO: implement later.
    private var wallCollisionType : CbType = new CbType();
    private var circleSensorType : CbType = new CbType();
    /*private var ballCollisionType : CbType = new CbType();*/

    public override function init() {
        create_borders();

        border_collision_listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, wallCollisionType, CbType.ANY_BODY, on_border_collision);
        Luxe.physics.nape.space.listeners.add(border_collision_listener);

        circle_sensor_listener = new InteractionListener(CbEvent.END, InteractionType.SENSOR, circleSensorType, CbType.ANY_BODY, on_circle_sensor);
        Luxe.physics.nape.space.listeners.add(circle_sensor_listener);
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

/*        //border.shapes.add(new nape.shape.Circle(200, new nape.geom.Vec2(Luxe.screen.w / 2, Luxe.screen.h / 2)));
        var circle_geometry = new phoenix.geometry.RingGeometry({
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h / 2,
            r: 200
        });

        var prev_v = null;
        var vec2a = new Array<nape.geom.Vec2>();
        var vec2a2 = new Array<nape.geom.Vec2>();
        for (v in circle_geometry.vertices) {

            vec2a.push(new nape.geom.Vec2(circle_geometry.transform.pos.x + v.pos.x, circle_geometry.transform.pos.y + v.pos.y));
            vec2a2.push(new nape.geom.Vec2(circle_geometry.transform.pos.x + v.pos.x + 5, circle_geometry.transform.pos.y + v.pos.y + 5));

            //trace('circle_geometry v: pos=${v.pos}, normal=${v.normal}');
            //if (prev_v != null) {
            //    border.shapes.add(new Polygon())
            //}

            //prev_v = v;
        }

        for (v in vec2a2) {
            vec2a.push(v);
        }*/
        
        var circle_body = new Body(BodyType.STATIC);
        var circle_shape = new Polygon(Polygon.regular(200, 200, 100));
        circle_body.shapes.add(circle_shape);
        circle_body.position.set(new nape.geom.Vec2(Luxe.screen.w / 2, Luxe.screen.h / 2));
        circle_shape.sensorEnabled = true;
        circle_shape.filter = new nape.dynamics.InteractionFilter(-1, -1, 1, -1, -1, -1);

        circle_body.space = Luxe.physics.nape.space;
        circle_body.cbTypes.add(circleSensorType);
        Main.debug_draw.add(circle_body);
    }

    private function on_border_collision(collision : InteractionCallback) {
        var obj : luxe.Entity = collision.int2.userData.obj;

        trace('on_border_collision: ${obj}');

        if (obj.get('shooter') == null) {
            obj.destroy();
            Luxe.events.fire('border_collision');
        }
    }

    private function on_circle_sensor(collision : InteractionCallback) {
        trace('sensor fired!');
    }
}