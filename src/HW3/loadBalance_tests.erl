-module(loadBalance_tests).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  loadBalance:startServers(),
  loadBalance:stopServers().

func_to_calc(ExpectedRes, Time) ->
  timer:sleep(Time),
  ExpectedRes.


simple_calc_test() ->
  loadBalance:startServers(),
  ?assertEqual(0, loadBalance:numberOfRunningFunctions(1)),
  Ref = make_ref(),
  loadBalance:calcFun(self(), fun() -> func_to_calc(25, 1000) end, Ref),
  receive
    {Ref, Res} -> ?assertEqual(25, Res)
  end,
  loadBalance:stopServers().


load_balance_test() ->
  loadBalance:startServers(),

  NumOfFunction = 10 * 3, % Should be divided equally by the 3 servers
  WaitTime = 1000, % in ms

  Functions = [{make_ref(), fun() -> func_to_calc(Res, WaitTime) end, Res} || Res <- lists:seq(1, NumOfFunction)],
  [loadBalance:calcFun(self(), Func, Ref) || {Ref, Func, _Res} <- Functions],
  % Check each server runs exactly one function
  RunningCounts = [loadBalance:numberOfRunningFunctions(ServerNum) || ServerNum <- lists:seq(1, 3)],
  ?assertEqual([round(NumOfFunction / 3) || _Server <- lists:seq(1, 3)], RunningCounts),
  [receive
     {Ref, Res} -> ?assertEqual(ExpectedRes, Res)
   end || {Ref, _Func, ExpectedRes} <- Functions],
  loadBalance:stopServers().

kill_servers_test() ->
  loadBalance:startServers(),
  [exit(whereis(ServerName), kill) || ServerName <- [server1, server2, server3]],
  timer:sleep(100),
  RunningCount = [loadBalance:numberOfRunningFunctions(ServerNum) || ServerNum <- lists:seq(1, 3)],
  ?assertEqual([0, 0, 0], RunningCount),
  loadBalance:stopServers().
