%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. kwi 2018 11:43
%%%-------------------------------------------------------------------
-module(pingpong).
-author("stormtrooper").

%% API
-export([start/0]).
-export([play/1]).
-export([stop/0]).

start() -> register(ping,spawn(fun () -> suppressing_shots() end)),
           register(pong,spawn(fun () -> suppressed() end)).

play(N) -> ping ! N.

stop() -> ping ! cease_fire,
          pong ! safe_again.

suppressing_shots() ->
  receive
    cease_fire -> io:format("fire_ceased~n");
    0 -> io:format("fire_ceased~n");
    N -> io:format("shot_fired~n"),
      timer:sleep(500),
      pong ! N-1,
      suppressing_shots()
  after
    20000 -> io:format("fire_ceased~n")
  end.

suppressed() ->
  receive
    safe_again -> io:format("still_alive~n");
    0 -> io:format("still_alive~n");
    N -> io:format("it_hurts~n"),
      timer:sleep(500),
      ping ! N-1,
      suppressed()
  after
    20000 -> still_alive
  end.