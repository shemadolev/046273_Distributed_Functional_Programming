
-module(shapes).

%% API
-export([shapesArea/1, squaresArea/1, trianglesArea/1, shapesFilter/1, shapesFilter2/1]).

% Returns the sum of areas of all the shapes in a shape structure
shapesArea({shapes, List}) ->
  erlang:error(not_implemented).

% Returns the sum of areas of all the squares in a shape structure
squaresArea({shapes, List}) ->
  erlang:error(not_implemented).

% Returns the sum of areas of all the triangles in a shape structure
trianglesArea({shapes, List}) ->
  erlang:error(not_implemented).

%  Returns a function, that gets a shapes structure and returns a shapes structure that has only shapes of the kind ShapeKind.
% ShapeKind may be one of: rectangle | ellipse | triangle
shapesFilter(ShapeKind) ->
  erlang:error(not_implemented).

% Returns a function, that gets a shapes structure and returns a shapes structure that has only shapes of the kind ShapeKind.
% ShapeKind may be one of: rectangle | ellipse | triangle | square | circle
shapesFilter2(ShapeKind) ->
  erlang:error(not_implemented).
