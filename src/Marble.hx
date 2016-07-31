package;

import luxe.Color;
import luxe.Entity;
import luxe.Sprite;
//import luxe.options.SpriteOptions;
import luxe.options.EntityOptions;
import luxe.components.physics.nape.CircleCollider;

import phoenix.geometry.CircleGeometry;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.phys.Material;

import util.Macros.*;

typedef MarbleOptions = {
//    > SpriteOptions,
    > EntityOptions,
    ? color : Color,
    ? radius : Float,
    ? mass : Float
}

class Marble extends Entity {
    public var color(default, default) : Color = new Color(1, 0, 0, 1);
    public var radius(default, default) : Float = 5;
    public var geometry(default, default) : CircleGeometry;

    public var mass(default, default) : Float = 0;

    public var collider(default, default) : CircleCollider;

    //private var body : Body;

    public override function new(?options : MarbleOptions) {
        options = def(options, {});
        radius = def(options.radius, radius);
        color = def(options.color, color);
        mass = def(options.mass, mass);

        super(options);
    }

    public override function destroy(?_from_parent : Bool = false) {
        geometry.drop(true);

        super.destroy(_from_parent);
    }

    public override function init() {
        geometry = Luxe.draw.circle({
            x: pos.x,
            y: pos.y,
            r: radius,
            color: color
        });

        collider = add(new CircleCollider({
            name: 'body',
            x: pos.x,
            y: pos.y,
            r: radius,
            body_type: BodyType.DYNAMIC
        }));

        collider.body.gravMass = mass;
        var material = Material.glass();
        //material.rollingFriction = 1000;
        collider.body.setShapeMaterials(material);
        //collider.body.isBullet = true;

        collider.body.userData.obj = this;

        Main.debug_draw.add(collider.body);
    }

    public override function update(dt : Float) {
        geometry.set(pos.x, pos.y, radius, radius, 60, 0, 0);
    }
}