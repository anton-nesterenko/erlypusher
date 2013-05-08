-module(ws_parser_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("erlson/include/erlson.hrl").
-define(COMMON_CHANNEL_JSON, erlson:from_json(<<"{\"event\":\"pusher:subscribe\",\"data\":{\"channel\":\"MY_CHANNEL\"}}">>)).
-define(AUTH_JSON, erlson:from_json(<<"{\"event\":\"pusher:subscribe\",\"data\":{\"channel\":\"MY_CHANNEL\", \"auth\": \"AUTHKEY\"}}">>)).
-define(DATA_JSON, erlson:from_json(<<"{\"event\":\"pusher:subscribe\",\"data\":{\"channel\":\"presence-example-channel\", \"auth\": \"AUTHKEY\", \"channel_data\": \"CHANNELOBJECT\"}}">>)).

-define(COMMON_CHANNEL, <<"MY_CHANNEL">>).
-define(PRIVATE_CHANNEL, <<"private-MY_CHANNEL">>).
-define(PRESENCE_CHANNEL, <<"presence-MY_CHANNEL">>).

generate_request_parser_test_() ->
   {setup,
    fun () -> erlson:init() end,
    [?_assertEqual(<<"pusher:subscribe">>, ws_parser:event(?COMMON_CHANNEL_JSON)),
     ?_assertEqual(<<"MY_CHANNEL">>, ws_parser:channel(?COMMON_CHANNEL_JSON)),
     ?_assertEqual(common, ws_parser:channel_type(?COMMON_CHANNEL)),
     ?_assertEqual(private, ws_parser:channel_type(?PRIVATE_CHANNEL)),
     ?_assertEqual(presence, ws_parser:channel_type(?PRESENCE_CHANNEL)),
     ?_assertEqual(<<"AUTHKEY">>, ws_parser:auth(?AUTH_JSON)),
     ?_assertEqual(<<"CHANNELOBJECT">>, ws_parser:channel_data(?DATA_JSON))]
   }.