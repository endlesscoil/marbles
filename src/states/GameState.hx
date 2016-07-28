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

    public override function onenter<T>(_ : T) {
        canvas = UI.canvas;

        Luxe.renderer.clear_color.rgb(0x0E7496);  // blue sky
    }

    public override function onleave<T>(_ : T) {

    }

    public override function update(dt : Float) {

    }

    public override function onkeyup(e : luxe.Input.KeyEvent) {
        Main.set_state('game_over');
    }
}