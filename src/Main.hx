import luxe.Input;
import luxe.States;

import ui.UI;

class Main extends luxe.Game 
{
    public static var ui : UI;
    public static var state : States;

    public static function set_state(state_name : String) {
        trace('Changing state to: ${state_name}');

        UI.canvas.destroy_children();
        state.set(state_name);
    }

    public override function config(config : luxe.GameConfig) {
        config.render.antialiasing = 2;

        return config;
    }

    public override function ready() {
        init_graphics();
        init_states();
        init_input();
    }

    public override function update(dt : Float) {
        handle_input();
    }

    public override function onkeyup(e : KeyEvent) {
        if (e.keycode == Key.escape)
            Luxe.shutdown();
    }

    private function handle_input() {

    }

    private function init_graphics() {
        // Create batchers for static landscape elements and UI.
        GameState.staticBatcher = Luxe.renderer.create_batcher({ name: 'static batcher', layer: 0 });
        GameState.uiBatcher = Luxe.renderer.create_batcher({ name: 'ui batcher', layer: 99 });

        // Initialize UI
        ui = new UI();
        ui.start(GameState.uiBatcher);
    }

    private function init_states() {
        state = new luxe.States();
        state.add(new states.Title({ name: 'title_screen' }));
        state.add(new states.GameState({ name: 'game' }));
        state.add(new states.GameOver({ name: 'game_over' }));

        set_state('title_screen');
    }

    private function init_input() {
        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);
        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);
        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);
        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);
    }
}
