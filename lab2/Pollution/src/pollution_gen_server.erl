%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. kwi 2018 11:57
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-author("stormtrooper").
-behaviour(gen_server).

%% API
-export([start_link/1]).
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([addStation/2]).
-export([addValue/4]).
-export([getOneValue/3]).
-export([stop/0]).
-export([crash/0]).

start_link(_) -> gen_server:start_link({local,pollution_gen_server},?MODULE,pollution:createMonitor(),[]).

init(IV) -> {ok,IV}.

stop() -> gen_server:cast(pollution_gen_server,commit_suicide).

handle_call({addStation,Name,Geo},_,M) ->
  Monitor=pollution:addStation(Name,Geo,M),
  case Monitor of
    cannotDuplicateStations -> {reply,cannotDuplicateStations,M};
    _ -> {reply,ok,Monitor}
  end;
handle_call({addValue,Ngeo,Date,Type,V},_,M) ->
  Monitor=pollution:addValue(M,Ngeo,Date,Type,V),
  case Monitor of
    cannotAddValueToNonExistentStation -> {reply,cannotAddValueToNonExistentStation,M};
    measureAlreadyExists -> {reply,measureAlreadyExists,M};
    _ -> {reply,ok,Monitor}
  end;
handle_call({getOneValue,Ngeo,Date,Type},_,M) ->
  R=pollution:getOneValue(M,Ngeo,Date,Type),
  case R of
    cannotGetMeasureFromNonExistentStation -> {reply,cannotGetMeasureFromNonExistentStation,M};
    cannotGetNonExistentMeasure -> {reply,cannotGetNonExistentMeasure,M};
    _ -> {reply,R,M}
  end;
handle_call(die,_,_) -> 5/0.

handle_cast(commit_suicide,_) -> i_will_put_a_bullet_in_my_head_in_3_2_1_bang.

addStation(Name,Geo) -> gen_server:call(pollution_gen_server,{addStation,Name,Geo}).

addValue(Ngeo,Date,Type,V) -> gen_server:call(pollution_gen_server,{addValue,Ngeo,Date,Type,V}).

getOneValue(Ngeo,Date,Type) -> gen_server:call(pollution_gen_server,{getOneValue,Ngeo,Date,Type}).

crash() -> gen_server:call(pollution_gen_server,die).