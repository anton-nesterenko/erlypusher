-module(erlypusher_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    erlypusher_config:prepare(),
    case application:get_env(erlypusher, port) of
      {ok, Port} ->
        Port;
      _ ->
        Port = 8080
    end,
    Dispatch = cowboy_router:compile([
                    %% {HostMatch, list({PathMatch, Handler, Opts})}
                    {'_', [{"/app/:key", websocket_handler, []},
                           {"/", main_page, []},
                           {"/apps/:app_id/channels/:channel_id/events", api_handler, []},
                           {"/apps/:app_id/events", api_handler, []},
                           {"/apps/:app_id/channels", channels_handler, []},
                           {"/apps/:app_id/channels/:channel_id", channels_handler, []},
                           {"/timeline/:id", timeline_handler, []}
                          ]}
                ]),
    cowboy:start_http(my_http_listener, 100,
        [{port, Port}],
        [{env, [{dispatch, Dispatch}]},
         {}
        ]
    ),
    erlypusher_sup:start_link().

stop(_State) ->
    ok.