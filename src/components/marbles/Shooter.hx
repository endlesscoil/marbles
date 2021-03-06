package components.marbles;

import luxe.Vector;
import luxe.Component;
import luxe.Color;
import luxe.utils.Maths;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;
import luxe.resource.Resource;

import snow.types.Types.AudioHandle;
import phoenix.geometry.CircleGeometry;

import nape.geom.Vec2;
import nape.shape.Circle;

class Shooter extends Component {
    public var mass : Float = 0;
    public var power : Float = 0;
    public var aiming_enabled : Bool = false;

    private var marble : Marble;
    private var aim_geometry : CircleGeometry = null;
    private var powerup_actuator : IGenericActuator;

    private var chargeup : AudioResource;
    private var chargeup_handle : AudioHandle;

    public override function init() {
        marble = cast entity;

        // TEMP
        power = 150;
        chargeup = Luxe.resources.audio('assets/chargeup.wav');

        //Main.debug_draw.remove(marble.collider.body);

        marble.collider.body.gravMass *= 0.5;
        marble.collider.body.shapes.clear();
        marble.collider.body.shapes.add(new Circle(marble.radius));
        //Main.debug_draw.add(marble.collider.body);

        if (marble.geometry != null)
            marble.geometry.drop(true);

        marble.geometry = Luxe.draw.circle({
            x: pos.x,
            y: pos.y,
            r: marble.radius,
            color: marble.color
        });
    }

    public override function onremoved() { }

    public override function update(dt : Float) { }

    public function shoot(target_pos : Vector, launch_power : Float) {
        var direction = get_direction(target_pos);
        var vel = direction.multiplyScalar(launch_power);

        marble.collider.body.applyImpulse(new Vec2(vel.x, vel.y));
    }

    public function aim(?target_pos : Vector) {
        // No target?  Destroy the aim reticle.
        if (target_pos == null) {
            if (aim_geometry != null) {
                aim_geometry.drop(true);
                aim_geometry = null;
            }
        }
        else {
            // Adjust position to outside the marble.
            var aim_pos = get_direction(target_pos).multiplyScalar(marble.radius + 5);

            // Draw or update geometry as necessary.
            if (aim_geometry == null) {
                aim_geometry = Luxe.draw.circle({
                    x: pos.x + aim_pos.x,
                    y: pos.y + aim_pos.y,
                    r: 2.5,                                           // FIXME: hardcoded radius
                    color: new Color(1, 1, 1, 1)
                });
            }
            else
                aim_geometry.set(pos.x + aim_pos.x, pos.y + aim_pos.y, 5, 5, 60, 0, 0);     // FIXME: hardcoded radius
        }
    }

    private function get_direction(target_pos : Vector) {
        return Vector.Subtract(target_pos, pos).normalize();
    }

    public function powerup(?v : Bool = true) {
        if (v) {
            if (aim_geometry == null)
                return;

            chargeup_handle = Luxe.audio.loop(chargeup.source, 0.5);
            powerup_actuator = Actuate.tween(aim_geometry.color, 0.75, { g: 0.1, b: 0.1 }).reflect().repeat();
        }
        else {
            Luxe.audio.stop(chargeup_handle);
            Actuate.stop(powerup_actuator);
        }
    }
}
