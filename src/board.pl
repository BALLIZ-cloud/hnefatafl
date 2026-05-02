% =====================================================================
% board.pl — Board Representation, Setup & Printing
% =====================================================================

:- module(board, [
    throne/2,
    corner/2,
    special_cell/2,
    pos_to_index/3,
    get_piece/4,
    set_piece/5,
    replace_at/4,
    setup_board/1,
    print_board/1,
    piece_role/2,
    duplicate_board/2
]).

% ---------------------------------------------------------------------
% Special squares
% ---------------------------------------------------------------------
throne(5, 5).

corner(0,  0).
corner(0,  10).
corner(10, 0).
corner(10, 10).

special_cell(R, C) :- throne(R, C).
special_cell(R, C) :- corner(R, C).

% ---------------------------------------------------------------------
% Index helpers
% ---------------------------------------------------------------------
pos_to_index(Row, Col, Index) :-
    Index is Row * 11 + Col.

get_piece(Board, Row, Col, Piece) :-
    pos_to_index(Row, Col, Index),
    nth0(Index, Board, Piece).

replace_at(0, [_|Tail], NewValue, [NewValue|Tail]) :- !.
replace_at(Index, [H|T], Value, [H|T2]) :-
    Index > 0,
    Index1 is Index - 1,
    replace_at(Index1, T, Value, T2).

set_piece(Board, Row, Col, Piece, NewBoard) :-
    pos_to_index(Row, Col, Index),
    replace_at(Index, Board, Piece, NewBoard).

% ---------------------------------------------------------------------
% Initial board setup (11x11)
% ---------------------------------------------------------------------
setup_board(Board) :-
    Board = [
     % R0
     empty,    empty,    empty,    attacker, attacker, attacker, attacker, attacker, empty,    empty,    empty,
     % R1
     empty,    empty,    empty,    empty,    empty,    attacker, empty,    empty,    empty,    empty,    empty,
     % R2
     empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,
     % R3
     attacker, empty,    empty,    empty,    empty,    defender, empty,    empty,    empty,    empty,    attacker,
     % R4
     attacker, empty,    empty,    empty,    defender, defender, defender, empty,    empty,    empty,    attacker,
     % R5 (center — king on throne)
     attacker, attacker, empty,    defender, defender, king,     defender, defender, empty,    attacker, attacker,
     % R6
     attacker, empty,    empty,    empty,    defender, defender, defender, empty,    empty,    empty,    attacker,
     % R7
     attacker, empty,    empty,    empty,    empty,    defender, empty,    empty,    empty,    empty,    attacker,
     % R8
     empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,    empty,
     % R9
     empty,    empty,    empty,    empty,    empty,    attacker, empty,    empty,    empty,    empty,    empty,
     % R10
     empty,    empty,    empty,    attacker, attacker, attacker, attacker, attacker, empty,    empty,    empty
    ].

% ---------------------------------------------------------------------
% Printing
% ---------------------------------------------------------------------
print_board(Board) :-
    nl,
    write('     0    1    2    3    4    5    6    7    8    9   10'), nl,
    write('  +----+----+----+----+----+----+----+----+----+----+----+'), nl,
    print_rows(Board, 0).

print_rows(_, 11) :- !.
print_rows(Board, Row) :-
    Row < 11,
    (Row < 10 -> format(' ~w |', [Row]) ; format('~w |', [Row])),
    print_cols(Board, Row, 0),
    nl,
    write('  +----+----+----+----+----+----+----+----+----+----+----+'), nl,
    NextRow is Row + 1,
    print_rows(Board, NextRow).

print_cols(_, _, 11) :- !.
print_cols(Board, Row, Col) :-
    Col < 11,
    get_piece(Board, Row, Col, Piece),
    piece_symbol(Piece, Row, Col, Symbol),
    format(' ~w  |', [Symbol]),
    NextCol is Col + 1,
    print_cols(Board, Row, NextCol).

piece_role(king,     'K').
piece_role(attacker, 'A').
piece_role(defender, 'D').
piece_role(empty,    '.').

piece_symbol(empty, R, C, Symbol) :-
    ( corner(R, C) -> Symbol = 'o'
    ; throne(R, C) -> Symbol = 'x'
    ; Symbol = '.'
    ).
piece_symbol(king,     _, _, 'K').
piece_symbol(attacker, _, _, 'A').
piece_symbol(defender, _, _, 'D').

duplicate_board(Board, BoardCopy) :-
    copy_term(Board, BoardCopy).
