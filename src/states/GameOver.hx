package states;

import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;

import mint.types.Types;
import mint.Canvas;
import mint.Image;

import ui.UI;

class GameOver extends State {
    private var txt_instructions : mint.Label;
    private var instructions_actuation : IGenericActuator;

    public override function onenter<T>(_ : T) {
        Luxe.renderer.clear_color.rgb(0x000000);

        create_ui();
    }

    public override function onleave<T>(_ : T) { }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        if (e.keycode == Key.escape)
            Luxe.shutdown();
    }

    private function create_ui() {
        var p1score = GameState.marbles_taken[0];
        var p2score = GameState.marbles_taken[1];

        var victor = "It's a tie game!";
        if (p1score > p2score) victor = "Player 1 wins!";
        else if (p2score > p1score) victor = "Player 2 wins!";

        txt_instructions = new mint.Label({
            parent: UI.canvas,
            name: 'instructions.text',
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h / 2 + 25,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 14,
            text: victor,
            options: {
                color: new Color(1, 1, 1, 0)        // Start totally transparent
            }
        });

        var t = cast(txt_instructions.renderer, mint.render.luxe.Label);
        instructions_actuation = Actuate.tween(t.text.color, 3, { a: 1 });
    }
}
