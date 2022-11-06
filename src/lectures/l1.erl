%%%-------------------------------------------------------------------
%%% @author shema
%%% @doc
%%%
%%% @end
%%% Created : 06. נוב׳ 2022 18:33
%%%-------------------------------------------------------------------
-module(l1).
-author("shema").

%% API
-export([hello/0, test_area/0, fib/1,pow/2, list_nth/2]).

hello() -> io:format("hello ~p!~n", [world]).

%% Multiple clauses
area({rect, W, H}) ->
  W * H;
area({square, Edge}) ->
  Edge * Edge;
area({circle,R})->
  math:pi() * R * R.

test_area()->
  io:format("area({circle,1.4}) = ~p~n",[area({circle,1.4})]), % 6.157521601035994
  io:format("area(1.4) = ~p~n",[area(1.4)]). % exception error: no function clause matching l1:area(1.4)

%% Fibonacci: Naive and not scalable solution (See l2 for better one, using Tail Recursion)
fib(1) -> 0;
fib(2) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

%Power of X^Y (Again, no Tail Recursion)
pow(_,0) -> 1;
pow(0,_) -> 0;
pow(X,Y) -> X * pow(X,Y-1).

% Return the Nth element in List
list_nth(1, [H | _]) -> H;
list_nth(Nth, [_ | T]) -> list_nth(Nth-1,T).
