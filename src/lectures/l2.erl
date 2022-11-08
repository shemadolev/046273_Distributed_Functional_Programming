%%%-------------------------------------------------------------------
%%% @author shema
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. נוב׳ 2022 23:01
%%%-------------------------------------------------------------------
-module(l2).
-author("shema").

%% API
-export([list_map/2, list_filter/2, find_main/1, try_catch_example/1, fib/1, fib_list/1, bump/1]).

%% bump w/ tail recursion
bump(L) -> lists:reverse(bump(L, [])).
bump([], Acc) -> Acc;
bump([H | T], Acc) -> bump(T, [H + 1 | Acc]).

%% fib w/ tail recursion. This can compute even fib(1000)
fib(I, I, [_, B]) -> B;
fib(M, I, [A, B]) -> fib(M, I + 1, [B, A + B]).
fib(N) when N > 0 -> fib(N, 1, [0, 1]).

fib_list(N) ->
  [fib(X) || X <- lists:seq(1, N)].

%% list map with tail recursion
list_map_aux(_, [], R) -> R;
list_map_aux(F, [H | T], R) -> list_map_aux(F, T, [F(H) | R]).
list_map(F, L) -> lists:reverse(list_map_aux(F, L, [])).

%% implementation for lists:filter
list_filter(_, []) -> [];
list_filter(F, [H | T]) ->
  case F(H) of
    true -> [H | list_filter(F, T)];
    false -> list_filter(F, T)
  end.

%% search in infinite list
next(Num) -> [Num | fun() -> next(Num + 1) end].
find(Pred, [Current | Next]) ->
  case Pred(Current) of
    true -> Current;
    false -> find(Pred, Next())
  end.
find_main(X) -> find(fun(N) -> X =:= N end, next(1)).

%% Try .. catch
try_catch_example(N) ->
  try gen_exception(N) of
    Val -> {N, normal, Val}
  catch
    throw: X -> {N, caught, thrown, X};
    exit: X -> {N, caught, exited, X};
    error: X -> {N, caught, error, X}
  end.

gen_exception(1) -> a; % => {1,normal,a}
gen_exception(2) -> throw(a); % => {2,caught,thrown,a}
gen_exception(3) -> erlang:error(a); % => {3,caught,error,a}
gen_exception(4) -> exit(a); % => {4,caught,exited,a}
gen_exception(X) -> 1 / X. %sent with X=0 => {0,caught,error,badarith}
