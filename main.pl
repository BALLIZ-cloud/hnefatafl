% =====================================================================
% main.pl — Entry Point
% Load this file in SWI-Prolog, then call: play.
% =====================================================================

:- use_module(src/board).
:- use_module(src/moves).
:- use_module(src/heuristic).
:- use_module(src/alphabeta).
:- use_module(src/controller).

:- initialization(play, main).
