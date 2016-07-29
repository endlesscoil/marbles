package states;

import luxe.Color;
import luxe.Vector;
import luxe.States;

import mint.types.Types;
import mint.Label;
import mint.Canvas;

import ui.UI;

class GameState extends State {
    private var canvas : Canvas;

    private var marbles : Array<Marble> = new Array<Marble>();

    private var shooter : Marble;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

        Luxe.renderer.clear_color.rgb(0x0E7496);  // blue sky

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

    }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        Main.set_state('game_over');
    }

    public override function onmousemove(event : luxe.Input.MouseEvent) {
        shooter.get('shooter').aim(event.pos);
    }
}