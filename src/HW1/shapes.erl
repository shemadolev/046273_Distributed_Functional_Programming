-module(shapes).

%% API
-export([shapesArea/1, squaresArea/1, trianglesArea/1, shapesFilter/1, shapesFilter2/1]).

%% Check if shapes structure is valid, by check that each of the shapes within it are valid
checkShape({rectangle, {dim, Width, Height}}) when Width > 0, Height > 0 -> true;
checkShape({triangle, {dim, Base, Height}}) when Base > 0, Height > 0 -> true;
checkShape({ellipse, {radius, Radius1, Radius2}}) when Radius1 > 0, Radius2 > 0 -> true.
checkShapesList([]) -> true;
checkShapesList([H | T]) -> checkShape(H) and checkShapesList(T).
checkShapes({shapes, ShapesList}) -> checkShapesList(ShapesList).

filterShapes([], _) -> [];
filterShapes([{rectangle, {dim, W, W}} | T], square) -> [{rectangle, {dim, W, W}} | filterShapes(T, square)];
filterShapes([{ellipse, {radius, R, R}} | T], circle) -> [{ellipse, {radius, R, R}} | filterShapes(T, circle)];
filterShapes([{ShapeKind, Dim} | T], ShapeKind) -> [{ShapeKind, Dim} | filterShapes(T, ShapeKind)];
filterShapes([_ | T], ShapeKind) -> filterShapes(T, ShapeKind).

% Returns a function, that gets a shapes structure and returns a shapes structure that has only shapes of the kind ShapeKind.
% ShapeKind may be one of: rectangle | ellipse | triangle
shapesFilter(ShapeKind)
  when ShapeKind =:= rectangle; ShapeKind =:= ellipse; ShapeKind =:= triangle
  ->
  fun({shapes, ShapeList}) ->
    checkShapesList(ShapeList),
    {shapes, filterShapes(ShapeList, ShapeKind)} end.

% Returns a function, that gets a shapes structure and returns a shapes structure that has only shapes of the kind ShapeKind.
% ShapeKind may be one of: rectangle | ellipse | triangle | square | circle
shapesFilter2(ShapeKind)
  when ShapeKind =:= rectangle; ShapeKind =:= ellipse; ShapeKind =:= triangle; ShapeKind =:= square; ShapeKind =:= circle
  ->
  fun({shapes, ShapeList}) ->
    checkShapesList(ShapeList),
    {shapes, filterShapes(ShapeList, ShapeKind)} end.

shapeArea({rectangle, {dim, Width, Height}}) -> Width * Height;
shapeArea({triangle, {dim, Base, Height}}) -> Base * Height / 2;
shapeArea({ellipse, {radius, Radius1, Radius2}}) -> math:pi() * Radius1 * Radius2.

% Returns the sum of areas of all the shapes in a shape structure
shapesArea({shapes, []}, Sum) -> Sum;
shapesArea({shapes, [H | T]}, Sum) -> shapesArea({shapes, T}, Sum + shapeArea(H)).

shapesArea(Shapes) ->
  checkShapes(Shapes),
  shapesArea(Shapes, 0).

filteredArea(Shapes, ShapeKind) ->
  FilteredShapes = (shapesFilter2(ShapeKind))(Shapes),
  shapesArea(FilteredShapes).

% Returns the sum of areas of all the squares in a shape structure
squaresArea(Shapes) -> filteredArea(Shapes, square).

trianglesArea(Shapes) -> filteredArea(Shapes, triangle).


%TODO All functions should fail if the list is not legal