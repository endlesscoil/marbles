package states;

import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.States;

import mint.types.Types;
import mint.Label;
import mint.Canvas;

import ui.UI;

class GameState extends State {
    private var canvas : Canvas;

    private var board : Board;
    private var marbles : Array<Marble> = new Array<Marble>();

    private var shooter : Marble;
    private var current_mouse_pos : Vector;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

        Luxe.renderer.clear_color.rgb(0x0E7496);  // blue sky

        current_mouse_pos = new Vector(0, 0);

        board = new Board();

        for (i in 0...13) {
            marbles.push(new Marble({
                radius: 10,
                color: new Color(Luxe.utils.random.float(0, 1), Luxe.utils.random.float(0, 1), Luxe.utils.random.float(0, 1), 1),
                pos: new Vector(Luxe.utils.random.float(0, Luxe.screen.w), Luxe.utils.random.float(0, Luxe.screen.h))
            }));
        }

        shooter = new Marble({
            radius: 10,
            color: new Color(1, 1, 1, 1),
            pos: new Vector(Luxe.screen.w / 2, Luxe.screen.h / 2)
        });
        shooter.add(new components.marbles.Shooter({ name: 'shooter' }));
    }

    public override function onleave<T>(_ : T) {

    }

    public override function update(dt : Float) {
        if (shooter.destroyed != true)
            shooter.get('shooter').aim(current_mouse_pos);
    }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        if (e.keycode == Key.space)
            shooter.get('shooter').shoot(current_mouse_pos);
    }

    public override function onmousemove(event : luxe.Input.MouseEvent) {
        current_mouse_pos = event.pos.clone();
    }
}