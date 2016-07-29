package components.marbles;

import luxe.Vector;
import luxe.Component;
import luxe.Color;
import luxe.utils.Maths;

import phoenix.geometry.CircleGeometry;

class Shooter extends Component {
    private var marble : Marble;

    private var aim_geometry : CircleGeometry = null;

    public override function init() {
        marble = cast entity;

        marble.radius *= 2;
        marble.geometry = Luxe.draw.circle({
            x: pos.x,
            y: pos.y,
            r: marble.radius,
            color: marble.color
        });
    }

    public override function update(dt : Float) {

    }

    public function shoot(direction : Vector) {

    }

    public function aim(target_pos : Vector) {
        var aim_pos = Vector.Subtract(target_pos, pos).normalize().multiplyScalar(marble.radius + 10);

        if (aim_geometry != null) aim_geometry.drop(true);

        aim_geometry = Luxe.draw.circle({
            x: pos.x + aim_pos.x,
            y: pos.y + aim_pos.y,
            r: 5,
            color: new Color(1, 0, 0, 1)
        });
    }
}