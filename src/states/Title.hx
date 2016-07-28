package states;

import luxe.States;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;

import mint.types.Types;
import mint.Canvas;

import ui.UI;

class Title extends State {
    private var canvas : Canvas;

    private var _txt_instructions : mint.Label;
    private var txt_instructions : mint.render.luxe.Label;
    private var instructions_actuation : IGenericActuator;

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

        Luxe.renderer.clear_color.rgb(0x000000);

        create_ui();
    }

    public override function onleave<T>(_ : T) {
        Actuate.stop(instructions_actuation);
        
        // Forcefully remove txt_instruction's child Text object.
        // Not sure why this is necessary.
        txt_instructions.text.destroy();
    }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        Main.set_state('game');
    }

    private function create_ui() {
        // TODO: Add logo, title, etc here.

        _txt_instructions = new mint.Label({
            parent: canvas,
            name: 'instructions.text',
            x: Luxe.screen.w / 2,
            y: Luxe.screen.h / 2 + 25,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text_size: 14,
            text: 'Press any key to continue'
        });

        txt_instructions = new mint.render.luxe.Label(UI.rendering, _txt_instructions);
        txt_instructions.color.a = 0.85;

        instructions_actuation = Actuate.tween(txt_instructions.color, 0.75, { a: 0.25 }).repeat().reflect();
    }
}