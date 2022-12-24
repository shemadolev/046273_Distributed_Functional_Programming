-module(matrix_server_tests).
-compile(export_all).

info() ->
	io:format(
"run_all() runs all the good tests,\n if it crushes there is something that me or you missed.\n
if a test fails, it\'s possible that you\'l need to shutdown the server.\n
run_upgrade_test needs to be spawned.\n 
after it starts it will check current version, then it will wait for you to send him a message.\n 
in the meantime you will change the version and it will recomiple matrix server and check the new version.\n
you can stop it at any time by sending him stop\n
see more about this test with how_to_run_upgrade_test()").

	
how_to_run_upgrade_test() -> 
	"Pid = spawn(matrix_server_tests, run_upgrade_test, []).
	update VersionIdentifier in matrix_server.erl
	Pid ! Msg.
	check that the version is the new one".
	
get_version()->
	MsgRef = make_ref(),
	matrix_server ! {self(), MsgRef, get_version},
	receive
		{MsgRef, VersionIdentifier} -> io:format('matrix_server ! {self(), MsgRef, get_version} version is ~w\n',[VersionIdentifier]);
		stop -> exit(normal)
		after 10000 -> exit(timeout)
	end,
	Version2 = matrix_server:get_version(),
	io:format('matrix_server:get_version() version is ~w\n',[Version2]).
	
run_upgrade_test() ->
	io:format('RUN_UPGRADE_TEST\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	get_version(), 
	io:format('you have 20 seconds\n'),
	receive
		stop -> 
			normal;
		_ -> 
			c:c(matrix_server),
			matrix_server ! sw_upgrade,
			get_version()
		after 20000 -> 
			userTimeout
	end,
	matrix_server ! shutdown.
	

	
do_mult1(Mat1, Mat2, Res) ->
% io:format(" do_mult1~n"),

 % io:format("Mat1 = ~p Mat2 =~p ~n",[Mat1,Mat2]),
	MsgRef = make_ref(),
	% io:format(" find server= ~p~n",[is_pid(whereis(matrix_server))]),
	% io:format(" self= ~p~n",[self()]),
	matrix_server ! {self(), MsgRef, {multiple, Mat1, Mat2}},
		% io:format(" meassage ~n") ,

	receive
		{MsgRef,Res} -> good
		after 1000 -> io:format('bad'), exit(bad)
	end.

do_mult2(Mat1, Mat2, Res) ->
	Res = matrix_server:mult(Mat1, Mat2).

test1() ->
	io:format('TEST 1.\nchecks if the server is registered after start_server(), and unregistered after shutdown()\n'),
	matrix_server:start_server(),
	timer:sleep(400),
	true = is_pid(whereis(matrix_server)),
	matrix_server:shutdown(),
	timer:sleep(400),
	false = is_pid(whereis(matrix_server)),
	io:format('and checks if the server is unregistered after getting shutdown message\n'),
	matrix_server:start_server(),
	timer:sleep(400),
	true = is_pid(whereis(matrix_server)),
	matrix_server ! shutdown,
	timer:sleep(400),%I added!!
	false = is_pid(whereis(matrix_server)),
	done.
	
test2() ->
	io:format('TEST 2.\neasiest matrix-multiplication: two matrices of 1X1\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	io:format('TEST 2. defaine matrices of 1X1\n'),
	Mat1 = {{3}},
	Mat2 = {{5}},
	Res = {{15}},
	io:format('TEST 2. run do_mult1\n'),
	do_mult1(Mat1, Mat2, Res),
	io:format('TEST 2. done do_mult1\n'),
	do_mult2(Mat1, Mat2, Res),
	matrix_server ! shutdown,
	done.
	
test3() ->
	io:format('TEST 3.\nnext stage: two matrices of 2X2\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Mat1 = {{1, 2}, {3, 4}},
	Mat2 = {{5, 6}, {7, 8}},
	Res = {{19, 22}, {43, 50}},
	do_mult1(Mat1, Mat2, Res),
	do_mult2(Mat1, Mat2, Res),
	matrix_server:shutdown(),
	done.
	
test4() ->
	io:format('TEST 4.\nlet\'s add real numbers: two real matrices of 2X2\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Mat1 = {{1.5, 3.3}, {9.5, 18.0}},
	Mat2 = {{0.1, 12.0}, {13.8, 5.5}},
	Res = {{45.69, 36.15}, {249.35, 213.0}},
	do_mult1(Mat1, Mat2, Res),
	do_mult2(Mat1, Mat2, Res),
	matrix_server ! shutdown,
	done.

test5() ->
	io:format('TEST 5.\nlet\'s mix real and integers: two real matrices of 2X2\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Mat1 = {{1.5, 3.3}, {9.5, 18}},
	Mat2 = {{0.1, 12}, {13.8, 5.5}},
	Res = {{45.69, 36.15}, {249.35, 213.0}},
	do_mult1(Mat1, Mat2, Res),
	do_mult2(Mat1, Mat2, Res),
	matrix_server:shutdown(),
	done.	
	
test6() ->
	io:format('TEST 6.\nhardest multiplication- different sizes: one 2X3 and one 3X4\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Mat1 = {{1.5, 3.3, 2}, {9.5, 17.2, 18}},
	Mat2 = {{0.1, 12, 5.5, 9}, {1, 2, 3, 4}, {3.14, 13.8, 5.5, 2.71}},
	Res = {{9.73, 52.2, 29.15, 32.12}, {74.67, 396.8, 202.85, 203.08}},
	do_mult1(Mat1, Mat2, Res),
	do_mult2(Mat1, Mat2, Res),
	matrix_server ! shutdown,
	done.
	
test7() ->
	io:format('TEST 7.\nnow two that makes two multiplicatios simultaneously\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Mat1 = {{1.5, 3.3, 2}, {9.5, 17.2, 18}},
	Mat2 = {{0.1, 12, 5.5, 9}, {1, 2, 3, 4}, {3.14, 13.8, 5.5, 2.71}},
	Res1 = {{9.73, 52.2, 29.15, 32.12}, {74.67, 396.8, 202.85, 203.08}},
	Mat3 = {{1.5, 3.3}, {9.5, 18}},
	Mat4 = {{0.1, 12}, {13.8, 5.5}},
	Res2 = {{45.69, 36.15}, {249.35, 213.0}},
	spawn_link(?MODULE, do_mult1, [Mat1, Mat2, Res1]),
	spawn_link(?MODULE, do_mult2, [Mat3, Mat4, Res2]),
	timer:sleep(300),
	matrix_server ! shutdown,
	done.	

test8(MsgRef, Res) ->
	receive
		{MsgRef,Res} -> good
		after 10000 -> bad
	end.

test8() ->
	io:format('TEST 8.\nnow one that makes two multiplicatios simultaneously\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Mat1 = {{1.5, 3.3, 2}, {9.5, 17.2, 18}},
	Mat2 = {{0.1, 12, 5.5, 9}, {1, 2, 3, 4}, {3.14, 13.8, 5.5, 2.71}},
	Res1 = {{9.73, 52.2, 29.15, 32.12}, {74.67, 396.8, 202.85, 203.08}},
	Mat3 = {{1.5, 3.3}, {9.5, 18}},
	Mat4 = {{0.1, 12}, {13.8, 5.5}},
	Res2 = {{45.69, 36.15}, {249.35, 213.0}},
	MsgRef1 = make_ref(),
	MsgRef2 = make_ref(),
	matrix_server ! {self(), MsgRef1, {multiple, Mat1, Mat2}},
	matrix_server ! {self(), MsgRef2, {multiple, Mat3, Mat4}},
	receive
		{MsgRef1,Res1} -> test8(MsgRef2,Res2);
		{MsgRef2,Res2} -> test8(MsgRef1,Res1)
		after 10000 -> bad
	end,
	matrix_server ! shutdown,
	done.

test9(Pid1, Pid2) when Pid1 /= Pid2 -> done.
test9() ->
	io:format('TEST 9.\nlet\'s kill our server and check if it reanimate\n'),
	matrix_server:start_server(),
	timer:sleep(300),
	Pid1 = whereis(matrix_server),
	exit(whereis(matrix_server), hi),
	timer:sleep(300),
	Pid2 = whereis(matrix_server),
	matrix_server:get_version(),
	test9(Pid1, Pid2),
	matrix_server ! shutdown,
	done.

test10() ->
	io:format('TEST 10.\nuse matrix_server:mult() without activating the server\n'),
	Mat1 = {{1, 2}, {3, 4}},
	Mat2 = {{5, 6}, {7, 8}},
	Res = {{19, 22}, {43, 50}},
	do_mult2(Mat1, Mat2, Res),
	done.
	
run_all() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, run_all_runner,[]),
	receive
		{'EXIT', Pid, normal} -> done;
		{'EXIT', Pid, _Msg} -> 
			matrix_server ! shutdown
	end.
	
run_all_runner() -> 
	test1(),
	test2(),
	test3(),
	test4(),
	test5(),
	test6(),
	test7(),
	test8(),
	test9(),
	test10(),
	done.