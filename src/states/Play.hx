package states;

import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.States;

import mint.types.Types;
import mint.Label;
import mint.Canvas;
import mint.Image;
import mint.Panel;

import ui.UI;
import GameState.InputState;
import GameState.TurnState;

class Play extends State {
    private var canvas : Canvas;

    private var board : Board;
    private var shooter : Marble;
    private var current_mouse_pos : Vector;
    private var launch_down_time : Float = -1;
    private var launch_timeout_timer : snow.api.Timer;

    private var panel_top : Panel;
    private var panel_bottom : Panel;
    private var panel_notice : Panel;
    private var _txt_instructions : Label;
    private var txt_instructions : mint.render.luxe.Label;
    private var _txt_marble_count1 : Label;
    private var txt_marble_count1 : mint.render.luxe.Label;
    private var _img_marble_count1 : Image;
    private var _txt_marble_count2 : Label;
    private var txt_marble_count2 : mint.render.luxe.Label;
    private var _img_marble_count2 : Image;
    private var _txt_notice : Label;
    private var txt_notice : mint.render.luxe.Label;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;
        create_ui();

        Luxe.renderer.clear_color.rgb(0x0E7496);  // blue sky

        current_mouse_pos = new Vector(0, 0);
        launch_down_time = -1;

        Luxe.events.listen('input_state_changed', on_input_state_changed);
        Luxe.events.listen('border_collision', on_border_collision);

        GameState.set_input_state(InputState.ChooseLaunchPosition);

        board = new Board();
        board.place_marbles(13);
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
                if (e.keycode == Key.space) {
                    if (launch_down_time == -1) {
                        trace('building up power: ${e.timestamp}');
                        launch_down_time = e.timestamp;
                        shooter.get('shooter').powerup();
                    }
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
                    var launch_power = Math.min(charge_time * shooter.get('shooter').power, shooter.get('shooter').power);

                    trace('launching!  charge_time=${charge_time}, launch_power=${launch_power}');
                    launch_down_time = -1;

                    shooter.get('shooter').powerup(false);
                    shooter.get('shooter').aiming_enabled = false;
                    shooter.get('shooter').aim(null);

                    shooter.get('shooter').shoot(current_mouse_pos, launch_power);

                    launch_timeout_timer = Luxe.timer.schedule(5, on_launch_timeout);
                }
            }

            default: {
                if (e.keycode == Key.key_n)
                    show_notice('testing', 5);
            }
        }
    }

    public override function onmousemove(e : luxe.Input.MouseEvent) {
        //trace('pos=${e.pos}, rel=${e.x_rel},${e.y_rel}');
        current_mouse_pos = e.pos.clone();
    }

    public override function onmouseup(e : luxe.Input.MouseEvent) {
        switch (GameState.inputState) {
            case InputState.ChooseLaunchPosition:
            {
                if (e.button == luxe.MouseButton.left) {
                    if (board.check_launch_point(e.pos))
                        set_instruction_text('Choose a location outside of the circle!', new Color(1, 0, 0, 1));
                    else {
                        Luxe.screen.cursor.grab = false;  // TODO: make false when not debugging, true otherwise
                        create_shooter(e.pos, 10);
                        shooter.get('shooter').aiming_enabled = true;

                        trace('Created shooter at pos: ${shooter.pos}');

                        GameState.set_input_state(InputState.LaunchMarble);
                    }
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
        Luxe.screen.cursor.grab = false;

        var playerTurn = if (GameState.turnState == TurnState.Player1) TurnState.Player2 else TurnState.Player1;

        GameState.turnState = playerTurn;
        trace('on_launch_timeout: new turnState: ${GameState.turnState}');
        GameState.set_input_state(InputState.ChooseLaunchPosition);
    }

    private function on_border_collision(e : Dynamic) {
        trace('marble captured');

        capture_marble();
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
        panel_top = new Panel({
            parent: UI.canvas,
            name: 'panel.top',
            x: 0,
            y: 0,
            w: Luxe.screen.w,
            h: 30 + 5 + 5,
            options: {
                color: new Color(0, 0, 0, 0.5)
            }
        });

        panel_bottom = new Panel({
            parent: UI.canvas,
            name: 'panel.bottom',
            x: 0,
            y: Luxe.screen.h - 30,
            w: Luxe.screen.w,
            h: 30,
            options: {
                color: new Color(0, 0, 0, 0.5)
            }
        });

        _txt_instructions = new Label({
            parent: panel_bottom,
            name: 'text.instructions',
            x: Luxe.screen.w / 2,
            y: 0,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 14,
            text: '',
            options: {
                color: new Color(1, 1, 1, 1)
            },
            depth: 99  // HACK: this shouldn't be needed, but seems it is.
        });

        txt_instructions = new mint.render.luxe.Label(UI.rendering, _txt_instructions);

        _img_marble_count1 = new Image({
            x: 5,
            y: 5,
            w: 30,
            h: 30,
            name: 'image.marble_count',
            parent: panel_top,
            path: 'assets/marble_count.png'
        });

        _txt_marble_count1 = new Label({
            parent: panel_top,
            name: 'text.marble_count',
            x: 5 + 30,
            y: 5,
            align: TextAlign.left,
            align_vertical: TextAlign.center,
            text_size: 16,
            text: '',
            options: {
                color: new Color(1, 1, 1, 1)
            }
        });

        txt_marble_count1 = new mint.render.luxe.Label(UI.rendering, _txt_marble_count1);
        txt_marble_count1.text.text = 'x0';

        _img_marble_count2 = new Image({
            x: Luxe.screen.w - 30 - 20 - 5,
            y: 5,
            w: 30,
            h: 30,
            name: 'image.marble_count',
            parent: panel_top,
            path: 'assets/marble_count.png'
        });

        _txt_marble_count2 = new Label({
            parent: panel_top,
            name: 'text.marble_count',
            x: Luxe.screen.w - 20 - 5,
            y: 5,
            align: TextAlign.left,
            align_vertical: TextAlign.center,
            text_size: 16,
            text: '',
            options: {
                color: new Color(1, 1, 1, 1)
            }
        });

        txt_marble_count2 = new mint.render.luxe.Label(UI.rendering, _txt_marble_count2);
        txt_marble_count2.text.text = 'x0';

        panel_notice = new Panel({
            parent: UI.canvas,
            name: 'panel.notice',
            x: Luxe.screen.w / 2 - 50,
            y: Luxe.screen.h / 2 - 30,
            w: 100,
            h: 60,
            options: {
                color: new Color(0, 0, 0, 0.25)
            }
        });
        panel_notice.visible = false;

        _txt_notice = new Label({
            parent: panel_notice,
            name: 'text.notice',
            x: panel_notice.w / 2,
            y: panel_notice.h / 2,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 18,
            text: '',
            options: {
                color: new Color(1, 1, 1, 1)
            }
        });

        //txt_notice = new mint.render.luxe.Label(UI.rendering, _txt_notice);
        //txt_notice.text.text = 'hi thar';
        _txt_notice.visible = false;
    }

    private function inputstate_to_directions(state : InputState) {
        switch (state) {
            case InputState.Idle: set_instruction_text('derp de derp de derp', new Color(1, 1, 1, 1));
            case InputState.ChooseLaunchPosition: set_instruction_text("Click the mouse button where you'd like to launch the shooter from.", new Color(1, 1, 1, 1));
            case InputState.LaunchMarble: set_instruction_text('Press and hold the space bar to charge your launch and then release it to shoot the marble!', new Color(1, 1, 1, 1));
        }
    }

    private function set_instruction_text(text : String, ?color : Color) {
        txt_instructions.text.text = '${text}';
        if (color != null)
            txt_instructions.text.color = color;
    }

    private function capture_marble() {
        var player = if (GameState.turnState == TurnState.Player1) 0 else 1;
        var score = GameState.score_point(player);

        trace('player=${player} score=${score}');

        if (player == 0)
            txt_marble_count1.text.text = 'x${score}';
        else
            txt_marble_count2.text.text = 'x${score}';
    }

    private function show_notice(text : String, time : Float) {
        var lbl = cast(_txt_notice.renderer, mint.render.luxe.Label);
        lbl.text.text = text;

        panel_notice.visible = true;
        for (child in panel_notice.children)
            child.visible = true;

        launch_timeout_timer = Luxe.timer.schedule(time, hide_notice);
    }

    private function hide_notice() {
        panel_notice.visible = false;
        for (child in panel_notice.children)
            child.visible = false;
    }
}