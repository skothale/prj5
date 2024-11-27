
%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- lines(X, []).

% Rules for parsing lines
lines([], []). % Base case: no input, no output.
lines(X, Remainder) :- line(X, Temp), colonOp(Temp, Temp2), lines(Temp2, Remainder).
lines(X, Remainder) :- line(X, Remainder). % Alternative case: single line.

% Rules for parsing a line
line(X, Remainder) :- nums(X, Temp), commaOp(Temp, Temp2), line(Temp2, Remainder).
line(X, Remainder) :- nums(X, Remainder). % Single number case.

% Rule for parsing numbers
nums([Digit | Rest], Remainder) :-
    digit(Digit),
    number_tail(Rest, Remainder).

number_tail([Digit | Rest], Remainder) :-
    digit(Digit), 
    number_tail(Rest, Remainder).
number_tail(Remainder, Remainder). % Base case: no more digits.

% Operators
colonOp([';' | T], T).
commaOp([',' | T], T).

% Rule for single-digit validation
digit(X) :-
    member(X, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
