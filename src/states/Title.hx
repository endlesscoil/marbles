package states;

import luxe.States;
import luxe.Color;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;

import mint.types.Types;
import mint.Canvas;

import ui.UI;

class Title extends State {
    private var canvas : Canvas;

    private var txt_instructions : mint.Label;
    private var instructions_actuation : IGenericActuator;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

        Luxe.renderer.clear_color.rgb(0x000000);

        create_ui();
    }

    public override function onleave<T>(_ : T) {
        Actuate.stop(instructions_actuation);
    }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        Main.set_state('play');
    }

    private function create_ui() {
        // TODO: Add logo, title, etc here.

        txt_instructions = new mint.Label({
            parent: canvas,
            name: 'instructions.text',
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h / 2 + 25,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 14,
            text: 'Press any key to continue',
            options: {
                color: new Color(1, 1, 1, 0.85)
            }
        });

        var t = cast(txt_instructions.renderer, mint.render.luxe.Label);
        instructions_actuation = Actuate.tween(t.text.color, 0.75, { a: 0.25 }).repeat().reflect();
    }
}