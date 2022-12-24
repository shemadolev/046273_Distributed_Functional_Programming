%% A module for multiplying 2 matrices and sending its result in a message
-module(matrix_mul).

%% API
-export([multiply/2]).

%% Multiplies Mat1*Mat2 in parallel: calculate each cell in the product using a separate process
multiply(Mat1, Mat2) ->
  Pid = self(),
  Mat1Rows = tuple_size(Mat1),
  Mat2Cols = tuple_size(element(1, Mat2)),
  [proc_utils:spawn_send(fun() -> Result = calc_cell(Mat1, Mat2, RowIdx, ColIdx), {RowIdx, ColIdx, Result} end, Pid)
    || RowIdx <- lists:seq(1, Mat1Rows), ColIdx <- lists:seq(1, Mat2Cols)],
  collect_cell_results(0, Mat1Rows * Mat2Cols, matrix:getZeroMat(Mat1Rows, Mat2Cols)).

%% Sum up all elements in a list
list_sum(List) ->
  lists:foldl(fun(X, Acc) -> X + Acc end, 0, List).

%% Calc the value of the cell in the position of [RowIdx,ColIdx] in the product of Mat1*Mat2
calc_cell(Mat1, Mat2, RowIdx, ColIdx) ->
  Mat1Row = matrix:getRow(Mat1, RowIdx),
  Mat2Col = matrix:getCol(Mat2, ColIdx),
  MulList = [element(Idx, Mat1Row) * element(Idx, Mat2Col) || Idx <- lists:seq(1, tuple_size(Mat1Row))],
  list_sum(MulList).

%% Collect all the results of each cell calculation from received messages, and combine them into one matrix.
collect_cell_results(N, N, Matrix) -> Matrix;
collect_cell_results(N, Total, Matrix) ->
  receive
    {Row, Col, Value} -> collect_cell_results(N + 1, Total, matrix:setElementMat(Row, Col, Matrix, Value))
  end.
