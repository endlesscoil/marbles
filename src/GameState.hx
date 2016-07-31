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
}
