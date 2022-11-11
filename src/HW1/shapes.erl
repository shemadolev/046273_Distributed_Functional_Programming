-module(shapes).

%% API
-export([shapesArea/1, squaresArea/1, trianglesArea/1, shapesFilter/1, shapesFilter2/1]).


%%legalShape({rectangle, {dim, Width, Height}}) when Width > 0, Height > 0 -> {rectangle, {dim, Width, Height}};
%%legalShape({triangle, {dim, Base, Height}}) when Base > 0, Height > 0 -> {triangle, {dim, Base, Height}};
%%legalShape({ellipse, {radius, Radius1, Radius2}}) when Radius1 > 0, Radius2 > 0 -> {ellipse, {radius, Radius1, Radius2}}.

filterShapes([], _) -> [];
filterShapes([{ShapeKind, Dim} | T], ShapeKind) -> [{ShapeKind, Dim} | filterShapes(T, ShapeKind)];
filterShapes([{rectangle, {dim, Width, Height}} | T], ShapeKind) when Width > 0, Height > 0 -> filterShapes(T, ShapeKind);
filterShapes([{triangle, {dim, Base, Height}} | T], ShapeKind) when Base > 0, Height > 0 -> filterShapes(T, ShapeKind);
filterShapes([{ellipse, {radius, Radius1, Radius2}} | T], ShapeKind) when Radius1 > 0, Radius2 > 0 -> filterShapes(T, ShapeKind).

% Returns a function, that gets a shapes structure and returns a shapes structure that has only shapes of the kind ShapeKind.
% ShapeKind may be one of: rectangle | ellipse | triangle
shapesFilter(ShapeKind) ->
  fun({shapes, ShapeList}) -> {shapes, filterShapes(ShapeList, ShapeKind)} end.

filterShapes2([], _) -> [];
filterShapes2([{rectangle, {dim, W, W}} | T], square) -> [{rectangle, {dim, W, W}} | filterShapes2(T, square)];
filterShapes2([{ellipse, {radius, R, R}} | T], circle) -> [{ellipse, {radius, R, R}} | filterShapes2(T, circle)];
filterShapes2([{ShapeKind, Dim} | T], ShapeKind) -> [{ShapeKind, Dim} | filterShapes2(T, ShapeKind)];
filterShapes2([{rectangle, {dim, Width, Height}} | T], ShapeKind) when Width > 0, Height > 0 -> filterShapes2(T, ShapeKind);
filterShapes2([{triangle, {dim, Base, Height}} | T], ShapeKind) when Base > 0, Height > 0 -> filterShapes2(T, ShapeKind);
filterShapes2([{ellipse, {radius, Radius1, Radius2}} | T], ShapeKind) when Radius1 > 0, Radius2 > 0 -> filterShapes2(T, ShapeKind).

% Returns a function, that gets a shapes structure and returns a shapes structure that has only shapes of the kind ShapeKind.
% ShapeKind may be one of: rectangle | ellipse | triangle | square | circle
shapesFilter2(ShapeKind) ->
  fun({shapes, ShapeList}) -> {shapes, filterShapes2(ShapeList, ShapeKind)} end.

shapeArea({rectangle, {dim, Width, Height}}) when Width > 0, Height > 0 -> Width * Height;
shapeArea({triangle, {dim, Base, Height}}) when Base > 0, Height > 0 -> Base * Height / 2;
shapeArea({ellipse, {radius, Radius1, Radius2}}) when Radius1 > 0, Radius2 > 0 -> math:pi() * Radius1 * Radius2.

% Returns the sum of areas of all the shapes in a shape structure
shapesArea({shapes, []}, Sum) -> Sum;
shapesArea({shapes, [H | T]}, Sum) -> shapesArea({shapes, T}, Sum + shapeArea(H)).

shapesArea({shapes, L}) -> shapesArea({shapes, L}, 0).

filteredArea(Shapes, ShapeKind) ->
  FilteredShapes = (shapesFilter2(ShapeKind))(Shapes),
  shapesArea(FilteredShapes).

% Returns the sum of areas of all the squares in a shape structure
squaresArea(Shapes) -> filteredArea(Shapes, square).

trianglesArea(Shapes) -> filteredArea(Shapes, triangle).


%TODO All functions should fail if the list is not legal