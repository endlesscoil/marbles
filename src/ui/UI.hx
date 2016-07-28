package ui;

import luxe.Text;
import luxe.Color;
import luxe.Vector;

import phoenix.Batcher;

import mint.Label;
import mint.focus.Focus;
import mint.render.luxe.LuxeMintRender;
import mint.layout.margins.Margins;
import mint.types.Types;

import ui.AutoCanvas;

class UI {
    public static var rendering : LuxeMintRender;
    public static var layout : Margins;
    public static var canvas : AutoCanvas;
    public static var focus : Focus;

    public function new() { }

    public function start(batcher : Batcher) {
        rendering = new LuxeMintRender({ batcher: batcher });
        layout = new Margins();

        var scale = Luxe.screen.device_pixel_ratio;

        canvas = new AutoCanvas({
            name: 'canvas',
            rendering: rendering,
            options: { color: new Color(1, 1, 1, 0.0) },
            scale: scale,
            x: 0,
            y: 0,
            w: Luxe.screen.w / scale,
            h: Luxe.screen.h / scale
        });

        canvas.auto_listen();

        focus = new Focus(canvas);
    }
}