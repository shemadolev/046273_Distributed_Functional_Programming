-module(loadBalance_tests).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  loadBalance:startServer(),
  loadBalance:stopServers().

func_to_calc(ExpectedRes, Time) ->
  timer:sleep(Time),
  ExpectedRes.


simple_calc_test() ->
  loadBalance:startServer(),
  ?assertEqual(0, loadBalance:numberOfRunningFunctions(1)),
  Ref = make_ref(),
  loadBalance:calcFun(self(), fun() -> func_to_calc(25, 1000) end, Ref),
  receive
    {Ref, Res} -> ?assertEqual(25, Res)
  end,
  loadBalance:stopServers().


load_balance_test() ->
  loadBalance:startServer(),
  NumOfFunction = 30,
  Functions = [{make_ref(), fun() -> func_to_calc(Res, 1000) end, Res} || Res <- lists:seq(1, NumOfFunction)],
  [loadBalance:calcFun(self(), Func, Ref) || {Ref, Func, _Res} <- Functions],
  % Check each server runs exactly one function
  RunningCounts = [loadBalance:numberOfRunningFunctions(ServerNum) || ServerNum <- lists:seq(1, 3)],
  ?assertEqual([round(NumOfFunction / 3) || _Server <- lists:seq(1,3)], RunningCounts),
  [receive
     {Ref, Res} -> ?assertEqual(ExpectedRes, Res)
   end || {Ref, _Func, ExpectedRes} <- Functions],
  loadBalance:stopServers().


%todo Test kill one of the servers, make sure comes back alive