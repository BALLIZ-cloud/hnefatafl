% =====================================================================
% controller.pl — Game Controller (Human vs Computer)
% =====================================================================

:- module(controller, [
    play/0
]).

:- use_module(board).
:- use_module(moves).
:- use_module(heuristic).
:- use_module(alphabeta).

% =====================================================================
% Entry point
% =====================================================================
play :-
    nl,
    write('================================================'), nl,
    write('        HNEFATAFL — Viking Chess (11x11)        '), nl,
    write('================================================'), nl,
    nl,
    choose_human_side(HumanSide),
    choose_difficulty(Difficulty),
    opposite_side(HumanSide, ComputerSide),
    setup_board(Board),
    nl,
    format('You play as: ~w~n', [HumanSide]),
    format('Computer plays as: ~w~n', [ComputerSide]),
    format('Difficulty: ~w~n', [Difficulty]),
    write('Attackers move first.'), nl,
    write('Board legend: K=King  A=Attacker  D=Defender  o=Corner  x=Throne  .=Empty'), nl,
    print_board(Board),
    game_loop(Board, attacker, HumanSide, ComputerSide, Difficulty).

% =====================================================================
% Game loop
% =====================================================================
game_loop(Board, CurrentSide, HumanSide, ComputerSide, Difficulty) :-
    ( game_over(Board, Winner) ->
        announce_winner(Winner)
    ;
        format('~n--- ~w\'s turn ---~n', [CurrentSide]),
        ( CurrentSide = HumanSide ->
            get_human_move(Board, CurrentSide, Move)
        ;
            write('Computer is thinking...'), nl,
            best_move(Board, CurrentSide, Difficulty, Move),
            Move = move(FR, FC, TR, TC),
            format('Computer moves: (~w,~w) -> (~w,~w)~n', [FR, FC, TR, TC])
        ),
        make_move(Board, Move, CurrentSide, NewBoard),
        print_board(NewBoard),
        opposite_side(CurrentSide, NextSide),
        game_loop(NewBoard, NextSide, HumanSide, ComputerSide, Difficulty)
    ).

% =====================================================================
% Human move input
% =====================================================================
get_human_move(Board, Side, Move) :-
    write('Enter your move — format: FromRow FromCol ToRow ToCol'), nl,
    write('> '),
    read_term(Input, []),
    ( parse_move(Input, Move) ->
        ( valid_move(Board, Side, Move) ->
            true
        ;
            write('Illegal move. Try again.'), nl,
            get_human_move(Board, Side, Move)
        )
    ;
        write('Invalid format. Example: move(2,5,4,5).  or just type: 2 5 4 5.'), nl,
        get_human_move(Board, Side, Move)
    ).

% Accept move(FR,FC,TR,TC) term directly
parse_move(move(FR, FC, TR, TC), move(FR, FC, TR, TC)) :-
    integer(FR), integer(FC), integer(TR), integer(TC).

% Validate move is in the legal move list
valid_move(Board, Side, Move) :-
    valid_moves(Board, Side, Moves),
    member(Move, Moves).

% =====================================================================
% Setup helpers
% =====================================================================
choose_human_side(Side) :-
    nl,
    write('Choose your side:'), nl,
    write('  1. attacker  (moves first, 24 pieces, tries to capture the King)'), nl,
    write('  2. defender  (12 pieces + King, tries to escape to a corner)'), nl,
    write('Enter 1 or 2: '),
    read(Choice),
    ( Choice = 1 -> Side = attacker
    ; Choice = 2 -> Side = defender
    ; write('Invalid choice. Please enter 1 or 2.'), nl,
      choose_human_side(Side)
    ).

choose_difficulty(Difficulty) :-
    nl,
    write('Choose difficulty:'), nl,
    write('  1. easy   (depth 1)'), nl,
    write('  2. medium (depth 3)'), nl,
    write('  3. hard   (depth 5)'), nl,
    write('Enter 1, 2 or 3: '),
    read(Choice),
    ( Choice = 1 -> Difficulty = easy
    ; Choice = 2 -> Difficulty = medium
    ; Choice = 3 -> Difficulty = hard
    ; write('Invalid choice. Please enter 1, 2 or 3.'), nl,
      choose_difficulty(Difficulty)
    ).

% =====================================================================
% Win announcement
% =====================================================================
announce_winner(defender) :-
    nl,
    write('================================================'), nl,
    write('  GAME OVER — DEFENDERS WIN! The King escaped!  '), nl,
    write('================================================'), nl.

announce_winner(attacker) :-
    nl,
    write('================================================'), nl,
    write('  GAME OVER — ATTACKERS WIN! The King is captured!'), nl,
    write('================================================'), nl.
