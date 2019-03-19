%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. kwi 2018 22:18
%%%-------------------------------------------------------------------
-module(pollution).
-author("stormtrooper").

%% API
-export([createMonitor/0]).
-export([addStation/3]).
-export([addValue/5]).
-export([removeValue/4]).
-export([getOneValue/4]).
-export([getStationMean/3]).
-export([getDailyAverageDataCount/2]).
-export([example/0]).

-record(monitor,{stations}).
-record(station,{name,geo,measures}).
-record(measure,{date,type,value}).

example() -> A=createMonitor(),
  B=addStation("Wietnam",{1,2},A),
  C=addStation("Hell",{3,4},B),
  D=addValue(C,"Wietnam",{2017,4,25},"Electronics",3154361614),
  E=addValue(D,"Wietnam",{2017,5,26},"Electronics2",5461545631),
  F=addValue(E,"Hell",{2017,5,26},"Heat",45784684),
  G=addValue(F,"Wietnam",{2017,5,26},"Napalm",457844),
  H=addValue(G,"Wietnam",{2017,5,26},"Napalm2",457844),
  I=addValue(H,"Wietnam",{2017,4,26},"Napalm",9999),
  I.

createMonitor() -> #monitor{stations=[]}.

addStation(Name,Geo,#monitor{stations=S}) -> DifferentName=not lists:any(fun(#station{name=N}) -> N==Name end,S),
                                             DifferentGeo=not lists:any(fun(#station{geo=G}) -> G==Geo end,S),
                                             case (DifferentName and DifferentGeo) of
                                               true -> New=#station{name=Name,geo=Geo,measures=[]},
                                                       #monitor{stations=[New|S]};
                                               false -> cannotDuplicateStations
                                             end.


addValue(M,Ngeo,Date,Type,V) -> case deleteStation(Ngeo,M) of
                                  cannotDeleteNonExistentStation -> cannotAddValueToNonExistentStation;
                                  _ -> {#station{name=N,geo=G,measures=Measures},
                                    #monitor{stations=S}}=deleteStation(Ngeo,M),
                                    Value=#measure{date=Date,type=Type,value=V},
                                    case lists:filter(fun(#measure{date=D,type=T}) -> {D,T}=={Date,Type} end,Measures) of
                                      [] -> New=#station{name=N,geo=G,measures=[Value|Measures]},
                                        #monitor{stations=[New|S]};
                                      _ -> measureAlreadyExists
                                    end
                                end.

removeValue(M,Ngeo,Date,Type) -> Value=getOneValue(M,Ngeo,Date,Type),
                                 case Value of
                                   cannotGetMeasureFromNonExistentStation -> cannotRemoveNonExistentValue;
                                   cannotGetNonExistentMeasure -> cannotRemoveNonExistentValue;
                                   _ -> {#station{name=N,geo=G,measures=Measure},
                                         #monitor{stations=S}}=deleteStation(Ngeo,M),
                                         New=#station{name=N,geo=G,measures=lists:delete(Value,Measure)},
                                         #monitor{stations=[New|S]}
                                 end.

getOneValue(#monitor{stations=S},Ngeo,Date,Type) -> case findStation(Ngeo,S) of
                                                      stationDoesNotExist -> cannotGetMeasureFromNonExistentStation;
                                                      _ -> #station{measures=Measure}=findStation(Ngeo,S),
                                                        case lists:filter(fun(#measure{date=D,type=T}) -> {D,T}=={Date,Type} end,Measure) of
                                                          [] -> cannotGetNonExistentMeasure;
                                                          [{_,_,_,X}|T] -> X
                                                        end
                                                    end.

getStationMean(#monitor{stations=S},Ngeo,Type) -> case findStation(Ngeo,S) of
                                                    stationDoesNotExist -> cannotGetMeanOfNonExistentStation;
                                                  _ -> #station{measures=Measure}=findStation(Ngeo,S),
                                                       Parameter=lists:filter(fun(#measure{type=T}) -> T==Type end,Measure),
                                                       lists:foldl(fun(#measure{value=V},N) -> V+N end,0,Parameter)/length(Parameter)
                                                  end.

findStation(Ngeo,Stations) -> case Ngeo of
                                {_,_} ->
                                  case lists:filter(fun(#station{geo=G}) -> G==Ngeo end,Stations) of
                                    [] -> stationDoesNotExist;
                                    [H|_] -> H
                                  end;
                                _ ->
                                  case lists:filter(fun(#station{name=N}) -> N==Ngeo end,Stations) of
                                    [] -> stationDoesNotExist;
                                    [H|_] -> H
                                  end
                              end.

deleteStation(Ngeo,#monitor{stations=S}) -> Station=findStation(Ngeo,S),
                                            case Station of
                                              stationDoesNotExist -> cannotDeleteNonExistentStation;
                                              _ -> {Station,#monitor{stations=lists:delete(Station,S)}}
                                            end.

getDailyAverageDataCount(#monitor{stations=S},Ngeo) -> Station=findStation(Ngeo,S),
                                                       case Station of
                                                         stationDoesNotExist -> cannotCountAverageMeasuresAmountFromNonExistentStation;
                                                         _ -> #station{measures=Measure}=findStation(Ngeo,S),
                                                              Measures=length(Measure),
                                                              Days=countDays(Measure,0),
                                                              Measures/Days
                                                       end.

countDays([],Acc) -> Acc;
countDays([_],Acc) -> Acc+1;
countDays([{_,Date1,_,_},X={_,Date2,_,_}|T],Acc) -> case Date1==Date2 of
                            true -> countDays([X|T],Acc);
                            false -> countDays([X|T],Acc+1)
                          end.
