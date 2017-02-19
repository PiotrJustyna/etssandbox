-module(etssandbox_app).

-behaviour(application).

-export([start/2, stop/1]).
-export([insert/2, delete_all/0, get_all/0, get/1]).

%% ==================================================
%% application ->
%% ==================================================

start(_StartType, _StartArgs) ->
  io:format("Starting.~n"),
  EtsInstanceName = create_storage(storage),
  io:format("Started ETS instance: ~p.~n", [EtsInstanceName]),
  etssandbox_sup:start_link().

stop(_State) ->
  io:format("Stopping.~n"),
  ok.

%% ==================================================
%% <- application
%% ==================================================

%% ==================================================
%% api ->
%% ==================================================

insert(Key, Value) ->
  InsertResult = ets:insert(storage, { Key, Value }),
  io:format("{\"insert\": ~p}~n", [InsertResult]),
  ok.

delete_all() ->
  DeleteAllResult = ets:delete_all_objects(storage),
  io:format("{\"deleteall\": ~p}~n", [DeleteAllResult]),
  ok.

get_all() ->
  StorageUnits = ets:info(storage, size),
  StorageMemoryInWords = ets:info(storage, memory),
  StorageMemoryInBytes = translate_words_to_megabytes(StorageMemoryInWords),
  io:format("{\"storageunits\": ~p, \"storagememoryinmeagabytes\": ~.2f}~n", [StorageUnits, StorageMemoryInBytes]),
  ok.

get(Key) ->
  Value = ets:lookup_element(storage, Key, 2),
  io:format("{\"value\": ~p}~n", [Value]),
  ok.

%% ==================================================
%% <- api
%% ==================================================

%% ==================================================
%% helpers ->
%% ==================================================

translate_words_to_bytes(Words) -> Words * 8.
translate_words_to_kilobytes(Words) -> translate_words_to_bytes(Words) / 1000.
translate_words_to_megabytes(Words) -> translate_words_to_kilobytes(Words) / 1000.
create_storage(StorageName) -> ets:new(StorageName, [set, named_table, public, { write_concurrency, true }, { read_concurrency, true }]).

%% ==================================================
%% <- helpers
%% ==================================================
