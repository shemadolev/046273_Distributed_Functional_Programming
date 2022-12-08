%% A module for multiplying 2 matrices and sending its result in a message
-module(matrix_mul).

%% API
-export([multiply/2]).

%% Multiplies 2 matrices
multiply(_Mat1, _Mat2) ->
  erlang:error(not_implemented).