% =====================================================================
% alphabeta.pl — Alpha-Beta Pruning & Difficulty Levels
% =====================================================================

:- module(alphabeta, [
    best_move/4,
    difficulty_depth/2,
    alpha_beta/7
]).

:- use_module(board).
:- use_module(moves).
:- use_module(heuristic).

% ---------------------------------------------------------------------
% Difficulty -> search depth
% ---------------------------------------------------------------------
difficulty_depth(easy,   1).
difficulty_depth(medium, 3).
difficulty_depth(hard,   5).

% ---------------------------------------------------------------------
% alpha_beta(+Board, +Depth, +Alpha, +Beta, +Side, -BestMove, -Score)
% ---------------------------------------------------------------------

% Terminal: depth 0
alpha_beta(Board, 0, _Alpha, _Beta, Side, none, Score) :-
    !,
    evaluate(Board, Side, Score).

% Terminal: game over
alpha_beta(Board, _Depth, _Alpha, _Beta, Side, none, Score) :-
    game_over(Board, _Winner), !,
    evaluate(Board, Side, Score).

% Recursive case
alpha_beta(Board, Depth, Alpha, Beta, Side, BestMove, BestScore) :-
    valid_moves(Board, Side, Moves),
    Moves \= [],
    opposite_side(Side, OppSide),
    NewDepth is Depth - 1,
    ab_loop(Board, Moves, NewDepth, Alpha, Beta, Side, OppSide,
            none, Alpha, BestMove, BestScore).

% Fallback: no moves
alpha_beta(Board, _Depth, _Alpha, _Beta, Side, none, Score) :-
    evaluate(Board, Side, Score).

% ---------------------------------------------------------------------
% ab_loop — iterates over moves with alpha-beta pruning
% ---------------------------------------------------------------------

% Base: no moves left
ab_loop(_Board, [], _Depth, _Alpha, _Beta, _Side, _OppSide,
        BestMove, BestScore, BestMove, BestScore).

% Recursive step
ab_loop(Board, [Move|Rest], Depth, Alpha, Beta, Side, OppSide,
        CurBestMove, CurBestScore, BestMove, BestScore) :-

    make_move(Board, Move, Side, NewBoard),

    alpha_beta(NewBoard, Depth, -Beta, -Alpha, OppSide, _, OppScore),
    Score is -OppScore,

    ( Score > CurBestScore ->
        NewBestMove  = Move,
        NewBestScore = Score
    ;
        NewBestMove  = CurBestMove,
        NewBestScore = CurBestScore
    ),

    NewAlpha is max(Alpha, NewBestScore),

    ( NewAlpha >= Beta ->
        BestMove  = NewBestMove,
        BestScore = NewBestScore
    ;
        ab_loop(Board, Rest, Depth, NewAlpha, Beta, Side, OppSide,
                NewBestMove, NewBestScore, BestMove, BestScore)
    ).

% ---------------------------------------------------------------------
% best_move(+Board, +Side, +Difficulty, -BestMove)
% ---------------------------------------------------------------------
best_move(Board, Side, Difficulty, BestMove) :-
    difficulty_depth(Difficulty, Depth),
    alpha_beta(Board, Depth, -1000000, 1000000, Side, BestMove, _Score).
