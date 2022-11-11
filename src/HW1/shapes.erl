
-module(shapes).

%% API
-export([shapesArea/1, squaresArea/1, trianglesArea/1, shapesFilter/1, shapesFilter2/1]).


shapesArea({shapes, List}) ->
  erlang:error(not_implemented).

squaresArea({shapes, List}) ->
  erlang:error(not_implemented).

trianglesArea({shapes, List}) ->
  erlang:error(not_implemented).

shapesFilter(ShapeKind) ->
  erlang:error(not_implemented).

shapesFilter2(ShapeKind) ->
  erlang:error(not_implemented).
