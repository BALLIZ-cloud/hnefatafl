% =====================================================================
% heuristic.pl — Utility / Heuristic Evaluation Function
% =====================================================================

:- module(heuristic, [
    evaluate/3,
    count_pieces/3,
    manhattan_to_nearest_corner/3,
    king_legal_moves_count/2,
    attackers_adjacent_to_king/2
]).

:- use_module(board).
:- use_module(moves).

% ---------------------------------------------------------------------
% count_pieces(+Board, +Side, -Count)
% ---------------------------------------------------------------------
count_pieces(Board, Side, Count) :-
    findall(1, (
        between(0, 10, R),
        between(0, 10, C),
        get_piece(Board, R, C, Piece),
        piece_belongs_to(Piece, Side)
    ), Ones),
    length(Ones, Count).

% ---------------------------------------------------------------------
% manhattan_to_nearest_corner(+KR, +KC, -Dist)
% ---------------------------------------------------------------------
manhattan_to_nearest_corner(KR, KC, Dist) :-
    findall(D, (
        corner(CR, CC),
        D is abs(KR - CR) + abs(KC - CC)
    ), Ds),
    min_list(Ds, Dist).

% ---------------------------------------------------------------------
% king_legal_moves_count(+Board, -Count)
% ---------------------------------------------------------------------
king_legal_moves_count(Board, Count) :-
    find_king(Board, KR, KC),
    findall(1, (
        between(0, 10, TR),
        between(0, 10, TC),
        can_slide(Board, KR, KC, TR, TC)
    ), Ones),
    length(Ones, Count).

% ---------------------------------------------------------------------
% attackers_adjacent_to_king(+Board, -Count)
% ---------------------------------------------------------------------
attackers_adjacent_to_king(Board, Count) :-
    find_king(Board, KR, KC),
    findall(1, (
        member((DR, DC), [(-1,0),(1,0),(0,-1),(0,1)]),
        NR is KR + DR,
        NC is KC + DC,
        NR >= 0, NR =< 10,
        NC >= 0, NC =< 10,
        get_piece(Board, NR, NC, attacker)
    ), Ones),
    length(Ones, Count).

% ---------------------------------------------------------------------
% evaluate(+Board, +Side, -Score)
%
% Positive = good for Side.
% Internally scored from defender's perspective, then flipped if needed.
%
% Components:
%   1. Piece count difference  (defender pieces vs attacker pieces)
%   2. King distance to corner (closer = better for defender)
%   3. King mobility           (more moves = better for defender)
%   4. Attacker threat         (more adjacent attackers = worse for defender)
% ---------------------------------------------------------------------
evaluate(Board, Side, Score) :-
    ( king_escaped(Board)              -> RawScore =  100000
    ; king_captured(Board)             -> RawScore = -100000
    ; valid_moves(Board, defender, []) -> RawScore = -100000
    ; valid_moves(Board, attacker, []) -> RawScore =  100000
    ;
        count_pieces(Board, attacker, AtkCount),
        count_pieces(Board, defender, DefCount),
        PieceDiff is DefCount * 10 - AtkCount * 5,

        find_king(Board, KR, KC),
        manhattan_to_nearest_corner(KR, KC, CornerDist),
        DistScore is -CornerDist * 8,

        king_legal_moves_count(Board, KingMoves),
        MobilityScore is KingMoves * 4,

        attackers_adjacent_to_king(Board, Threats),
        ThreatScore is -Threats * 15,

        RawScore is PieceDiff + DistScore + MobilityScore + ThreatScore
    ),
    ( Side = attacker -> Score is -RawScore ; Score = RawScore ).
