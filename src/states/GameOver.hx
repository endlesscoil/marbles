package states;

import luxe.Input;
import luxe.States;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;

import mint.types.Types;
import mint.Canvas;
import mint.Image;

import ui.UI;

class GameOver extends State {
    private var canvas : Canvas;

    private var _txt_instructions : mint.Label;
    private var txt_instructions : mint.render.luxe.Label;
    private var instructions_actuation : IGenericActuator;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

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

        _txt_instructions = new mint.Label({
            parent: canvas,
            name: 'instructions.text',
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h / 2 + 25,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 14,
            text: victor
        });

        txt_instructions = new mint.render.luxe.Label(UI.rendering, _txt_instructions);
        txt_instructions.color.a = 0.0;

        instructions_actuation = Actuate.tween(txt_instructions.color, 3, { a: 1 });
    }
}
