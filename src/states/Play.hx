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
    private var launch_timeout_timer : snow.api.Timer;

    private var _txt_instructions : Label;
    private var txt_instructions : mint.render.luxe.Label;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;
        create_ui();

        Luxe.renderer.clear_color.rgb(0x0E7496);  // blue sky

        current_mouse_pos = new Vector(0, 0);
        launch_down_time = -1;

        Luxe.events.listen('input_state_changed', on_input_state_changed);

        GameState.set_input_state(InputState.ChooseLaunchPosition);

        board = new Board();

        for (i in 0...13) {
            marbles.push(new Marble({
                radius: 10,
                color: new Color(Luxe.utils.random.float(0, 1), Luxe.utils.random.float(0, 1), Luxe.utils.random.float(0, 1), 1),
                pos: new Vector(Luxe.utils.random.float(0, Luxe.screen.w), Luxe.utils.random.float(0, Luxe.screen.h))
            }));
        }
    }

    public override function onleave<T>(_ : T) {
        Luxe.timer.reset();
    }

    public override function update(dt : Float) {
        if (GameState.inputState == InputState.LaunchMarble && shooter != null && shooter.destroyed != true && shooter.get('shooter').aiming_enabled == true)
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

                    shooter.get('shooter').aiming_enabled = false;
                    shooter.get('shooter').aim(null);

                    launch_timeout_timer = Luxe.timer.schedule(5, on_launch_timeout);
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
                    //shooter.pos = e.pos.clone();


                    create_shooter(e.pos, 10);
                    shooter.get('shooter').aiming_enabled = true;

                    trace('Created shooter at pos: ${shooter.pos}');

                    //shooter.collider.body.position.setxy(e.pos.x, e.pos.y);

                    GameState.set_input_state(InputState.LaunchMarble);
                }
            }

            default: {}
        }
    }

    private function on_input_state_changed(e : Dynamic) {
        trace('got input state change: ${e.previous_state} -> ${e.new_state}');

        inputstate_to_directions(e.new_state);
    }

    private function on_launch_timeout() {
        shooter.destroy();
        shooter = null;

        GameState.set_input_state(InputState.ChooseLaunchPosition);
    }

    private function create_shooter(pos : Vector, radius : Int) {
        if (shooter != null)
            shooter.destroy();

        shooter = new Marble({
            radius: radius,
            color: new Color(1, 1, 1, 1),
            pos: pos.clone()
        });
        shooter.add(new components.marbles.Shooter({ name: 'shooter' }));
    }

    private function create_ui() {
        _txt_instructions = new Label({
            parent: UI.canvas,
            name: 'text.instructions',
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h - 30,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 14,
            text: '',
            options: {
                color: new Color(1, 1, 1, 1)
            }
        });

        txt_instructions = new mint.render.luxe.Label(UI.rendering, _txt_instructions);
    }

    private function inputstate_to_directions(state : InputState) {
        switch (state) {
            case InputState.Idle: set_instruction_text('derp de derp de derp');
            case InputState.ChooseLaunchPosition: set_instruction_text("Click the mouse button where you'd like to launch the shooter from.");
            case InputState.LaunchMarble: set_instruction_text('Press and hold the space bar to charge your launch and then release it to shoot the marble!');
        }
    }

    private function set_instruction_text(text : String) {
        txt_instructions.text.text = '${text}';
    }
}