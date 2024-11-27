%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

% Define the initial state
initial_state(state(Position, no_red_key, no_blue_key, no_black_key)) :-
    initial(Position).

% Define generic movement
take_action(state(From, RedKey, BlueKey, BlackKey), move(From, To), state(To, RedKey, BlueKey, BlackKey)) :-
    door(From, To);
    door(To, From).

% Define key collection actions
take_action(state(From, no_red_key, BlueKey, BlackKey), move(From, To), state(To, has_red_key, BlueKey, BlackKey)) :-
    door(From, To),
    key(To, red).

take_action(state(From, RedKey, no_blue_key, BlackKey), move(From, To), state(To, RedKey, has_blue_key, BlackKey)) :-
    door(From, To),
    key(To, blue).

take_action(state(From, RedKey, BlueKey, no_black_key), move(From, To), state(To, RedKey, BlueKey, has_black_key)) :-
    door(From, To),
    key(To, black).

% Define locked door actions
take_action(state(From, RedKey, BlueKey, BlackKey), move(From, To), state(To, RedKey, BlueKey, BlackKey)) :-
    (locked_door(From, To, blue); locked_door(To, From, blue)),
    BlueKey = has_blue_key.

take_action(state(From, RedKey, BlueKey, BlackKey), move(From, To), state(To, RedKey, BlueKey, BlackKey)) :-
    (locked_door(From, To, red); locked_door(To, From, red)),
    RedKey = has_red_key.

take_action(state(From, RedKey, BlueKey, BlackKey), move(From, To), state(To, RedKey, BlueKey, BlackKey)) :-
    (locked_door(From, To, black); locked_door(To, From, black)),
    BlackKey = has_black_key.

% Define final state
final_state(state(Position, _, _, _)) :-
    treasure(Position).

% Define steps recursively
take_steps(State, [Action], FinalState) :-
    take_action(State, Action, FinalState).

take_steps(State, [Action | Rest], FinalState) :-
    take_action(State, Action, IntermediateState),
    take_steps(IntermediateState, Rest, FinalState).


search(Actions) :-
    initial_state(InitialState),
    length(Actions, _),
    take_steps(InitialState, Actions, FinalState),
    final_state(FinalState), !.

