package;

enum TurnState {
    Player1;
    Player2;
}

enum InputState {
	Idle;
	ChooseLaunchPosition;
	LaunchMarble;
}

class GameState {
    public static var staticBatcher : phoenix.Batcher;
    public static var uiBatcher : phoenix.Batcher;

    public static var inputState : InputState = InputState.Idle;
    public static var turnState : TurnState = TurnState.Player1;
    public static var marbles_taken : Array<Int> = [0, 0];

    public static function set_input_state(inputState : InputState) {
        var oldInputState = GameState.inputState;
        GameState.inputState = inputState;

        Luxe.events.fire('input_state_changed', { previous_state: oldInputState, new_state: inputState });
    }

    public static function score_point(player : Int) : Int {
        marbles_taken[player]++;

        return marbles_taken[player];
    }
}
