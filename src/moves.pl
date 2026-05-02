% =====================================================================
% moves.pl — Move Generation, Captures & Game-Over Detection
% =====================================================================

:- module(moves, [
    piece_belongs_to/2,
    valid_moves/3,
    can_slide/5,
    apply_move/3,
    apply_captures/4,
    make_move/4,
    enemy_piece/2,
    is_unarmed/1,
    find_king/3,
    king_escaped/1,
    king_captured/1,
    game_over/2,
    opposite_side/2
]).

:- use_module(board).

% ---------------------------------------------------------------------
% Piece ownership
% ---------------------------------------------------------------------
piece_belongs_to(attacker, attacker).
piece_belongs_to(defender, defender).
piece_belongs_to(king,     defender).

is_unarmed(king).

enemy_piece(attacker, defender).
enemy_piece(attacker, king).
enemy_piece(defender, attacker).

opposite_side(attacker, defender).
opposite_side(defender, attacker).

% ---------------------------------------------------------------------
% Move generation
% ---------------------------------------------------------------------
valid_moves(Board, Side, Moves) :-
    findall(
        move(FR, FC, TR, TC),
        (   between(0, 10, FR),
            between(0, 10, FC),
            get_piece(Board, FR, FC, Piece),
            piece_belongs_to(Piece, Side),
            between(0, 10, TR),
            between(0, 10, TC),
            can_slide(Board, FR, FC, TR, TC)
        ),
        Moves
    ).

% Horizontal slide
can_slide(Board, FR, FC, FR, TC) :-
    FC =\= TC,
    get_piece(Board, FR, TC, empty),
    \+ (special_cell(FR, TC), \+ get_piece(Board, FR, FC, king)),
    clear_horizontal_path(Board, FR, FC, TC).

% Vertical slide
can_slide(Board, FR, FC, TR, FC) :-
    FR =\= TR,
    get_piece(Board, TR, FC, empty),
    \+ (special_cell(TR, FC), \+ get_piece(Board, FR, FC, king)),
    clear_vertical_path(Board, FC, FR, TR).

clear_horizontal_path(Board, Row, FC, TC) :-
    FC < TC, Mid is FC + 1, all_empty_cols(Board, Row, Mid, TC).
clear_horizontal_path(Board, Row, FC, TC) :-
    FC > TC, Mid is TC + 1, all_empty_cols(Board, Row, Mid, FC).

all_empty_cols(_, _, Limit, Limit) :- !.
all_empty_cols(Board, Row, C, Limit) :-
    C < Limit,
    get_piece(Board, Row, C, empty),
    Next is C + 1,
    all_empty_cols(Board, Row, Next, Limit).

clear_vertical_path(Board, Col, FR, TR) :-
    FR < TR, Mid is FR + 1, all_empty_rows(Board, Col, Mid, TR).
clear_vertical_path(Board, Col, FR, TR) :-
    FR > TR, Mid is TR + 1, all_empty_rows(Board, Col, Mid, FR).

all_empty_rows(_, _, Limit, Limit) :- !.
all_empty_rows(Board, Col, R, Limit) :-
    R < Limit,
    get_piece(Board, R, Col, empty),
    Next is R + 1,
    all_empty_rows(Board, Col, Next, Limit).

% ---------------------------------------------------------------------
% Applying a move
% ---------------------------------------------------------------------
apply_move(Board, move(FR, FC, TR, TC), NewBoard) :-
    get_piece(Board, FR, FC, Piece),
    set_piece(Board, FR, FC, empty, Tmp),
    set_piece(Tmp, TR, TC, Piece, NewBoard).

% ---------------------------------------------------------------------
% Capture logic
% ---------------------------------------------------------------------
ally_for_capture(_, R, C, _) :- corner(R, C), !.
ally_for_capture(_, R, C, Board) :-
    throne(R, C),
    get_piece(Board, R, C, Piece),
    Piece \= king, !.
ally_for_capture(Side, R, C, Board) :-
    R >= 0, R =< 10, C >= 0, C =< 10,
    get_piece(Board, R, C, Piece),
    piece_belongs_to(Piece, Side),
    \+ is_unarmed(Piece).

apply_captures(Board, move(_, _, TR, TC), Side, NewBoard) :-
    try_capture(Board,  Side, TR, TC, -1,  0, B1),
    try_capture(B1,     Side, TR, TC,  1,  0, B2),
    try_capture(B2,     Side, TR, TC,  0, -1, B3),
    try_capture(B3,     Side, TR, TC,  0,  1, NewBoard).

try_capture(Board, Side, R, C, DR, DC, NewBoard) :-
    NR  is R  + DR,  NC  is C  + DC,
    NR2 is NR + DR,  NC2 is NC + DC,
    NR  >= 0, NR  =< 10, NC  >= 0, NC  =< 10,
    NR2 >= 0, NR2 =< 10, NC2 >= 0, NC2 =< 10,
    get_piece(Board, NR, NC, EnemyPiece),
    enemy_piece(Side, EnemyPiece),
    EnemyPiece \= king,
    ally_for_capture(Side, NR2, NC2, Board), !,
    set_piece(Board, NR, NC, empty, NewBoard).
try_capture(Board, _, _, _, _, _, Board).

% ---------------------------------------------------------------------
% King location & end conditions
% ---------------------------------------------------------------------
find_king(Board, KR, KC) :-
    between(0, 10, KR),
    between(0, 10, KC),
    get_piece(Board, KR, KC, king), !.

king_escaped(Board) :-
    find_king(Board, KR, KC),
    corner(KR, KC).

king_captured(Board) :-
    find_king(Board, KR, KC),
    \+ corner(KR, KC),
    king_surrounded(Board, KR, KC).

king_surrounded(Board, KR, KC) :-
    hostile_to_king(Board, KR, KC, -1,  0),
    hostile_to_king(Board, KR, KC,  1,  0),
    hostile_to_king(Board, KR, KC,  0, -1),
    hostile_to_king(Board, KR, KC,  0,  1).

hostile_to_king(_, KR, KC, DR, DC) :-
    NR is KR + DR, NC is KC + DC,
    ( NR < 0 ; NR > 10 ; NC < 0 ; NC > 10 ), !.
hostile_to_king(_, KR, KC, DR, DC) :-
    NR is KR + DR, NC is KC + DC,
    corner(NR, NC), !.
hostile_to_king(Board, KR, KC, DR, DC) :-
    NR is KR + DR, NC is KC + DC,
    throne(NR, NC),
    get_piece(Board, NR, NC, Piece),
    Piece \= king, !.
hostile_to_king(Board, KR, KC, DR, DC) :-
    NR is KR + DR, NC is KC + DC,
    get_piece(Board, NR, NC, attacker).

game_over(Board, defender) :- king_escaped(Board), !.
game_over(Board, attacker) :- king_captured(Board), !.
game_over(Board, attacker) :- valid_moves(Board, defender, []), !.
game_over(Board, defender) :- valid_moves(Board, attacker, []), !.

% ---------------------------------------------------------------------
% Combined move + capture
% ---------------------------------------------------------------------
make_move(Board, Move, Side, NewBoard) :-
    apply_move(Board, Move, TempBoard),
    apply_captures(TempBoard, Move, Side, NewBoard).
