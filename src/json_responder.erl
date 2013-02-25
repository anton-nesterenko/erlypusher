-module(json_responder).

-export([response/0, response/1]).

response({ok_connection, SocketId}) ->
  % jiffy:encode({[{<<"event">>, <<"pusher:connection_established">>},
                 % {<<"data">>, {[{<<"socket_id">>, SocketId}]}}]});
  "{\"event\": \"pusher:connection_established\", \"data\": {\"socket_id\": \"" ++ SocketId ++ "\"}}";

response({ok_channel, ChannelName}) ->
  % jiffi:encode({[{<<"event">>, <<"pusher_internal:connection_succeedeed">>},
  %                {<<"data">>, {[]}},
  %                {<<"channel">>, ChannelName}]});
  "{\"event\": \"pusher_internal:connection_succeedeed\", \"data\": {}, \"channel\": \"" ++ binary_to_list(ChannelName) ++ "\"}";

response({ping}) ->
  "{\"event\": \"pusher:pong\", \"data\": {}}";

% errors

response({error_no_app, AppId}) ->
  "{\"type\":\"PusherError\",\"data\":{\"code\":4001,\"message\":\"Could not find app by key " ++ binary_to_list(AppId) ++ "\"}}";

response(_Any) ->
  ok.

response() ->
  ok.