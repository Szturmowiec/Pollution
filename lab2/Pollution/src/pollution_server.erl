%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. kwi 2018 19:40
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("stormtrooper").

%% API
-import(pollution,[createMonitor/0,addStation/3,addValue/5,removeValue/4,getOneValue/4,getStationMean/3,getDailyAverageDataCount/2]).

-export([start/0]).
-export([stop/0]).
-export([init/1]).
-export([addStation/2]).
-export([addValue/4]).
-export([removeValue/3]).
-export([getOneValue/3]).
-export([getStationMean/2]).
-export([getDailyAverageDataCount/1]).

start() -> register(server,spawn_link(pollution_server, init,[createMonitor()])).

stop() -> server ! commit_suicide.

init(M) -> loop(M).

loop(M) ->
  receive
    commit_suicide -> io:format("i_will_put_a_bullet_in_my_head_in_3_2_1_bang~n");
    {Pid,addStation,Name,Geo} ->
      Monitor=addStation(Name,Geo,M),
      Pid ! Monitor,
      case Monitor of
        cannotDuplicateStations -> loop(M);
        _ -> loop(Monitor)
      end;
    {Pid,addValue,Ngeo,Date,Type,V} ->
      Monitor=addValue(M,Ngeo,Date,Type,V),
      Pid ! Monitor,
      case Monitor of
        cannotAddValueToNonExistentStation -> loop(M);
        measureAlreadyExists -> loop(M);
        _ -> loop(Monitor)
      end;
    {Pid,removeValue,Ngeo,Date,Type} ->
      Monitor=removeValue(M,Ngeo,Date,Type),
      Pid ! Monitor,
      case Monitor of
        cannotRemoveNonExistentValue -> loop(M);
        _ -> loop(Monitor)
      end;
    {Pid,getOneValue,Ngeo,Date,Type} ->
      R=getOneValue(M,Ngeo,Date,Type),
      Pid ! R,
      loop(M);
    {Pid,getStationMean,Ngeo,Type} ->
      R=getStationMean(M,Ngeo,Type),
      Pid ! R,
      loop(M);
    {Pid,getDailyAverageDataCount,Ngeo} ->
      R=getDailyAverageDataCount(M,Ngeo),
      Pid ! R
  end.

addStation(Name,Geo) ->
  server ! {self(),addStation,Name,Geo},
  receive
    M -> M
  end.

addValue(Ngeo,Date,Type,V) ->
  server ! {self(),addValue,Ngeo,Date,Type,V},
  receive
    M -> M
  end.

removeValue(Ngeo,Date,Type) ->
  server ! {self(),removeValue,Ngeo,Date,Type},
  receive
    M -> M
  end.

getOneValue(Ngeo,Date,Type) ->
  server ! {self(),getOneValue,Ngeo,Date,Type},
  receive
    R -> R
  end.

getStationMean(Ngeo,Type) ->
  server ! {self(),getStationMean,Ngeo,Type},
  receive
    R -> R
  end.

getDailyAverageDataCount(Ngeo) ->
  server ! {self(),getDailyAverageDataCount,Ngeo},
  receive
    R -> R
  end.