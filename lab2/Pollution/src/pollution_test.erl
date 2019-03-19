%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. kwi 2018 21:30
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("stormtrooper").

%% API
-import(pollution,[example/0,createMonitor/0,addStation/3,addValue/5,removeValue/4,getOneValue/4,getStationMean/3,getDailyAverageDataCount/2]).

-include_lib("eunit/include/eunit.hrl").

getOneValue1_test() -> ?assertEqual(457844,getOneValue(example(),"Wietnam",{2017,5,26},"Napalm")).

getOneValue2_test() -> ?assertEqual(cannotGetNonExistentMeasure,getOneValue(example(),"Wietnam",{2017,7,26},"Napalm")).

getStationMean1_test() -> ?assertEqual(233921.5,getStationMean(example(),"Wietnam","Napalm")).

getStationMean2_test() -> ?assertEqual(cannotGetMeanOfNonExistentStation,getStationMean(example(),"Wietnam2","Napalm")).

getDailyAverageDataCount1_test() -> ?assertEqual(1.6666666666666667,getDailyAverageDataCount(example(),"Wietnam")).

getDailyAverageDataCount2_test() -> ?assertEqual(cannotCountAverageMeasuresAmountFromNonExistentStation,getDailyAverageDataCount(example(),"WIETnam2")).
