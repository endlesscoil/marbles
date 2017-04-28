package;

import luxe.Entity;
import luxe.Vector;
import luxe.Color;
import phoenix.geometry.RingGeometry;

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
    public var circle_body : Body;
    private var circle_geometry : RingGeometry;

    private var border_collision_listener : InteractionListener;
    private var circle_sensor_listener : InteractionListener;

    private var wallCollisionType : CbType = new CbType();
    private var circleSensorType : CbType = new CbType();
    /*private var ballCollisionType : CbType = new CbType();*/  // TODO: implement later.

    public override function init() {
        create_borders();

        // Listener for screen border collisions
        border_collision_listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, wallCollisionType, CbType.ANY_BODY, on_border_collision);
        Luxe.physics.nape.space.listeners.add(border_collision_listener);

        // Listener for marble circle exits
        circle_sensor_listener = new InteractionListener(CbEvent.END, InteractionType.SENSOR, circleSensorType, CbType.ANY_BODY, on_circle_sensor);
        Luxe.physics.nape.space.listeners.add(circle_sensor_listener);
    }

    public override function update(dt : Float) { }

    public override function destroy(?_from_parent : Bool = false) {
        //Main.debug_draw.remove(border);
        //Main.debug_draw.remove(circle_body);

        circle_geometry.drop(true);
    }

    private function create_borders() {
        border = new Body(BodyType.STATIC);

        // Create screen borders
        var pax = Constants.PLAYABLE_X_OFFSETS;
        var pay = Constants.PLAYABLE_Y_OFFSETS;

        border.shapes.add(new Polygon(Polygon.rect(pax[0], pay[0], Luxe.screen.w + pax[1], -1)));
        border.shapes.add(new Polygon(Polygon.rect(pax[0], Luxe.screen.h + pay[1], Luxe.screen.w + pax[1], 1)));
        border.shapes.add(new Polygon(Polygon.rect(pax[0], pay[0], -1, Luxe.screen.h + pay[1])));
        border.shapes.add(new Polygon(Polygon.rect(Luxe.screen.w + pax[1], pay[0], 1, Luxe.screen.h + pay[1])));
        border.space = Luxe.physics.nape.space;
        border.cbTypes.add(wallCollisionType);
        //Main.debug_draw.add(border);

        // Create marble circle for use as a listener.
        circle_body = new Body(BodyType.STATIC);
        var circle_shape = new Polygon(Polygon.regular(200, 200, 100));
        circle_body.shapes.add(circle_shape);
        circle_body.position.set(new nape.geom.Vec2(Luxe.screen.w / 2, Luxe.screen.h / 2));
        circle_shape.sensorEnabled = true;
        circle_shape.filter = new nape.dynamics.InteractionFilter(-1, -1, 1, -1, -1, -1);       // Sensor group 1
        circle_body.space = Luxe.physics.nape.space;
        circle_body.cbTypes.add(circleSensorType);
        //Main.debug_draw.add(circle_body);

        var circle_color = new Color().rgb(0xBABABA);
        circle_color.a = 0.5;

        circle_geometry = Luxe.draw.ring({
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h / 2,
            r: 200,
            color: circle_color
        });
    }

    public function place_marbles(number : Int) {
        for (i in 0...number) {
            // Get a random spot in our unit circle
            var p = Luxe.utils.geometry.random_point_in_unit_circle();

            // Multiply by circle radius to give us an actual random point on our screen.
            p.multiplyScalar(200);      // HACK: hardcoded circle radius.

            // Apply position offset of circle;
            p.x += Luxe.screen.w / 2;
            p.y += Luxe.screen.h / 2;

            marbles.push(new Marble({
                radius: 5,
                color: new luxe.Color(Luxe.utils.random.float(0, 1), Luxe.utils.random.float(0, 1), Luxe.utils.random.float(0, 1), 1),
                pos: p.clone()
            }));
        }
    }

    public function check_launch_point(p : Vector) {
        var vertices : Array<Vector> = [];

        // Convert nape polygon vertices into something that point_in_polygon will understand.
        for (v in circle_body.shapes.at(0).castPolygon.localVerts) {
            vertices.push(new Vector(v.x, v.y));
        }

        return Luxe.utils.geometry.point_in_polygon(p, new Vector(circle_body.position.x, circle_body.position.y), vertices);
    }

    private function on_border_collision(collision : InteractionCallback) {
        var obj : luxe.Entity = collision.int2.userData.obj;
        trace('on_border_collision: ${obj}');
    }

    private function on_circle_sensor(collision : InteractionCallback) {
        var obj : luxe.Entity = collision.int2.userData.obj;
        if (obj == null || obj.destroyed == true) {
            trace('Sensor triggered by deleted entity.');
            return;
        }

        trace('circle sensor: ${obj}');

        if (obj.get('shooter') == null) {
            // Remove the marble from our list and destroy it.
            marbles.remove(cast obj);
            obj.destroy();

            Luxe.events.fire('border_collision');
        }
    }
}
