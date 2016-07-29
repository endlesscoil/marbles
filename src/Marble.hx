package;

import luxe.Color;
import luxe.Entity;
import luxe.Sprite;
//import luxe.options.SpriteOptions;
import luxe.options.EntityOptions;

import phoenix.geometry.CircleGeometry;
import util.Macros.*;

typedef MarbleOptions = {
//    > SpriteOptions,
    > EntityOptions,
    ? color: Color,
    ? radius: Float
}

class Marble extends Entity {
    public var color(default, default) : Color = new Color(1, 0, 0, 1);
    public var radius(default, default) : Float = 5;
    public var geometry(default, default) : CircleGeometry;

    public override function new(?options : MarbleOptions) {
        options = def(options, {});
        radius = def(options.radius, radius);
        color = def(options.color, color);

        super(options);
    }

    public override function init() {
        geometry = Luxe.draw.circle({
            x: pos.x,
            y: pos.y,
            r: radius,
            color: color
        });
    }

    public override function update(dt : Float) {

    }
}