%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%


% Define the initial state
initial_state(state(Position, no_red_key, no_blue_key, no_black_key)) :- 
    initial(Position).

% Generic move action for open doors
move_action(state(From, RedKey, BlueKey, BlackKey), To, state(To, RedKey, BlueKey, BlackKey)) :- 
    (door(From, To); door(To, From)).

% Move and pick up keys
pick_key(state(From, no_red_key, BlueKey, BlackKey), To, red, state(To, has_red_key, BlueKey, BlackKey)).
pick_key(state(From, RedKey, no_blue_key, BlackKey), To, blue, state(To, RedKey, has_blue_key, BlackKey)).
pick_key(state(From, RedKey, BlueKey, no_black_key), To, black, state(To, RedKey, BlueKey, has_black_key)).

% Move through locked doors if the corresponding key is available
unlock_door(state(From, has_red_key, BlueKey, BlackKey), To, red, state(To, has_red_key, BlueKey, BlackKey)).
unlock_door(state(From, RedKey, has_blue_key, BlackKey), To, blue, state(To, RedKey, has_blue_key, BlackKey)).
unlock_door(state(From, RedKey, BlueKey, has_black_key), To, black, state(To, RedKey, BlueKey, has_black_key)).

% Take an action: move, pick up a key, or unlock a door
take_action(CurrentState, move(From, To), NextState) :-
    CurrentState = state(From, RedKey, BlueKey, BlackKey),
    (   move_action(CurrentState, To, NextState)
    ;   key(To, KeyColor), pick_key(CurrentState, To, KeyColor, NextState)
    ;   locked_door(From, To, KeyColor), unlock_door(CurrentState, To, KeyColor, NextState)
    ;   locked_door(To, From, KeyColor), unlock_door(CurrentState, To, KeyColor, NextState)
    ).

% Define the final state as reaching the treasure
final_state(state(Position, _, _, _)) :- 
    treasure(Position).

% Recursive steps to transition from state to state
take_steps(State, [Action], FinalState) :- 
    take_action(State, Action, FinalState).

take_steps(State, [Action | Rest], FinalState) :-
    take_action(State, Action, IntermediateState),
    take_steps(IntermediateState, Rest, FinalState).

% Main search logic
search(Actions) :-
    initial_state(InitialState),
    length(Actions, _),
    take_steps(InitialState, Actions, FinalState),
    final_state(FinalState), !.