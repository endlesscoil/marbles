package;

enum InputState {
	Idle;
	ChooseLaunchPosition;
	LaunchMarble;
}

class GameState {
    public static var staticBatcher : phoenix.Batcher;
    public static var uiBatcher : phoenix.Batcher;

    public static var inputState : InputState = InputState.Idle;

    public static function set_input_state(inputState : InputState) {
        var oldInputState = GameState.inputState;
        GameState.inputState = inputState;

        Luxe.events.fire('input_state_changed', { previous_state: oldInputState, new_state: inputState });
    }
}
