package;

import luxe.Color;
import luxe.Entity;
import luxe.Sprite;
import luxe.Vector;
import luxe.options.EntityOptions;
import luxe.components.physics.nape.CircleCollider;
import luxe.resource.Resource;
import snow.types.Types.AudioHandle;
import phoenix.geometry.CircleGeometry;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.phys.Material;

import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionCallback;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;

import util.Macros.*;

typedef MarbleOptions = {
//    > SpriteOptions,
    > EntityOptions,
    ? color : Color,
    ? radius : Float,
    ? mass : Float
}

class Marble extends Entity {
    public var geometry(default, default) : CircleGeometry;
    public var collider(default, default) : CircleCollider;

    public var radius(default, default) : Float = 5;
    public var mass(default, default) : Float = 0;
    public var color(default, default) : Color = new Color(1, 0, 0, 1);

    private var marbleCollisionType : CbType = new CbType();
    private var marble_collision_listener : InteractionListener;

    private var ballhit : AudioResource;
    private var ballhit_handle : AudioHandle;

    public override function new(?options : MarbleOptions) {
        options = def(options, {});
        radius = def(options.radius, radius);
        color = def(options.color, color);
        mass = def(options.mass, mass);

        super(options);
    }

    public override function destroy(?_from_parent : Bool = false) {
        geometry.drop(true);
        collider.body.userData.obj = null;

        super.destroy(_from_parent);
    }

    public override function init() {
        ballhit = Luxe.resources.audio('assets/ballhit.wav');

        geometry = Luxe.draw.circle({
            x: pos.x,
            y: pos.y,
            r: radius,
            color: color
        });

        marble_collision_listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, marbleCollisionType, CbType.ANY_BODY, on_collision);
        Luxe.physics.nape.space.listeners.add(marble_collision_listener);

        collider = add(new CircleCollider({
            name: 'body',
            x: pos.x,
            y: pos.y,
            r: radius,
            body_type: BodyType.DYNAMIC
        }));

        collider.body.gravMass = mass;
        collider.body.space = Luxe.physics.nape.space;
        collider.body.cbTypes.add(marbleCollisionType);

        var material = Material.glass();
        collider.body.setShapeMaterials(material);
        collider.body.setShapeFilters(new nape.dynamics.InteractionFilter(-1, -1, 1, -1, -1, -1));  // Sensor group 1

        collider.body.userData.obj = this;

        //Main.debug_draw.add(collider.body);
    }

    public override function update(dt : Float) {
        // Update geometry as physics moves the object.
        // NOTE: This will be uncessary when this is converted to a sprite.
        geometry.set(pos.x, pos.y, radius, radius, 60, 0, 0);
    }

    public override function set_pos(new_pos : Vector) : phoenix.Vector {
        if(collider != null) {
            trace('setting collider pos');
            collider.body.position.setxy(new_pos.x, new_pos.y);
        }

        if (geometry != null) {
            geometry.set(pos.x, pos.y, radius, radius, 60, 0, 0);
        }

        pos.set_xy(new_pos.x, new_pos.y);

        return pos;
    }

    public function stop() {
        collider.body.velocity = new nape.geom.Vec2(0, 0);
    }

    private function on_collision(collision : InteractionCallback) {

        var intensity = collision.int2.castBody.velocity.length / 20;
        var volume = Math.min(Math.max(intensity, 0), 10) / 10;

        ballhit_handle = Luxe.audio.play(ballhit.source, volume);
    }
}
