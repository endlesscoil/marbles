import luxe.Input;

class Main extends luxe.Game
{
    public override function config(config : luxe.AppConfig) {
        return config;
    }

    public override function ready() : Void
    {
        init_graphics();
        init_input();
    }

    public override function update(dt : Float) : Void
    {
        handle_input();
    }

    public override function onkeyup(e : KeyEvent) : Void
    {
        if (e.keycode == Key.escape)
            Luxe.shutdown();
    }

    private function handle_input() : Void
    {

    }

    private function init_graphics() : Void
    {

    }

    private function init_input() : Void
    {

    }
}
