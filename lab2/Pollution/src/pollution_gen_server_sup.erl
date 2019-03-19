%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. maj 2018 22:33
%%%-------------------------------------------------------------------
-module(pollution_gen_server_sup).
-author("stormtrooper").

%% API
-export([start/0]).
-export([stop/0]).
-export([init/0]).

start() -> register(gen_server_sup,spawn(pollution_gen_server_sup,init,[])).

init() -> process_flag(trap_exit,true),
  loop().

stop() -> gen_server_sup ! kill.

loop() -> pollution_gen_server:start_link(5),
  pollution_gen_server:init(5),
  receive
    kill -> io:format("bleeding_out~n"),
      pollution_gen_server:stop();
      {'EXIT',_,_} -> loop()
  end.