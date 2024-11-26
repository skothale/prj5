
%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- lines(X, []).

lines([], []).
lines(X, A) :- line(X, Y), colonOp(Y, Z), lines(Z, A).
lines(X, Y) :- line(X, Y).

line(X, A) :- num(X, Y), commaOp(Y, Z), line(Z, A).
line(X, Y) :- num(X, Y).

num(X, Y) :- digit(X, Y).
num(X, Z) :- digit(X, Y), num(Y, Z).

colonOp([';' | T], T).
commaOp([',' | T], T).

digit([X | T], T) :-
    member(X, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
