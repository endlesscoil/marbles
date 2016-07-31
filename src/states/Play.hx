package states;

import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.States;

import mint.types.Types;
import mint.Label;
import mint.Canvas;

import ui.UI;
import GameState.InputState;

class Play extends State {
    private var canvas : Canvas;

    private var board : Board;
    private var marbles : Array<Marble> = new Array<Marble>();

    private var shooter : Marble;
    private var current_mouse_pos : Vector;
    private var launch_down_time : Float = -1;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

        Luxe.renderer.clear_color.rgb(0x0E7496);  // blue sky

        current_mouse_pos = new Vector(0, 0);
        launch_down_time = -1;

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

    public override function onkeydown(e : luxe.Input.KeyEvent) {
        switch (GameState.inputState) {
            case InputState.LaunchMarble:
            {
                if (launch_down_time == -1) {
                    trace('building up power: ${e.timestamp}');
                    launch_down_time = e.timestamp;
                }
            }

            default: {}
        }
    }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        switch (GameState.inputState) {
            case InputState.LaunchMarble:
            {
                if (e.keycode == Key.space) {
                    var charge_time = (e.timestamp - launch_down_time);
                    var launch_power = charge_time * shooter.get('shooter').power;

                    trace('launching!  charge_time=${charge_time}, launch_power=${launch_power}');

                    shooter.get('shooter').shoot(current_mouse_pos, launch_power);
                    launch_down_time = -1;
                }
            }

            default: {}
        }
    }

    public override function onmousemove(e : luxe.Input.MouseEvent) {
        current_mouse_pos = e.pos.clone();
    }

    public override function onmouseup(e : luxe.Input.MouseEvent) {
        switch (GameState.inputState) {
            case InputState.ChooseLaunchPosition:
            {
                if (e.button == luxe.MouseButton.left) {
                    shooter.collider.body.position.setxy(e.pos.x, e.pos.y);
                    //shooter.pos = e.pos.clone();

                    trace('Setting shooter pos to: ${shooter.pos}');

                    GameState.inputState = InputState.LaunchMarble;
                }
            }

            default: {}
        }
    }
}