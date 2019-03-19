%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. kwi 2018 11:34
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("stormtrooper").

%% API
-export([start/0]).
-export([stop/0]).
-export([init/0]).

start() -> register(server_sup,spawn(pollution_server_sup,init,[])).

init() -> process_flag(trap_exit,true),
  loop().

stop() -> server_sup ! kill.

loop() -> pollution_server:start(),
  receive
    kill -> server ! commit_suicide,
      io:format("bleeding_out~n");
    {'EXIT',_,_} -> loop()
  end.