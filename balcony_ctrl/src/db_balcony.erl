-module(db_balcony).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("db_balcony.hrl").


-define(TABLE,balcony_info).
-define(RECORD,balcony_info).

create_table()->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)}]),
    mnesia:wait_for_tables([?TABLE], 20000).
create_table(NodeList)->
    mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)},
				 {disc_copies,NodeList}]),
    mnesia:wait_for_tables([?TABLE], 20000).

create([?MODULE,Id,ActualTemp]) ->
    create(Id,ActualTemp).
create(Id,ActualTemp) ->
    Record=#?RECORD{id=Id,actual_temp=ActualTemp},
    F = fun() -> mnesia:write(Record) end,
    mnesia:transaction(F).

read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    [Temp]= [XTemp||{?RECORD,_XId,XTemp}<-Z],
    Temp.



read(Id) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		   X#?RECORD.id==Id])),
   [Temp]= [XTemp||{?RECORD,_XId,XTemp}<-Z],
    Temp.

update(Id,NewTemp) ->
    F = fun() -> 
		RecordList=[X||X<-mnesia:read({?TABLE,Id}),
			    X#?RECORD.id==Id],
		case RecordList of
		    []->
			mnesia:abort(?TABLE);
		    [S1]->
			mnesia:delete_object(S1), 
			mnesia:write(#?RECORD{id=Id,actual_temp=NewTemp})
		end
	end,
    mnesia:transaction(F).

delete(Id) ->

    F = fun() -> 
		RecordList=[X||X<-mnesia:read({?TABLE,Id}),
			    X#?RECORD.id==Id],
		case RecordList of
		    []->
			mnesia:abort(?TABLE);
		    [S1]->
			mnesia:delete_object(S1) 
		end
	end,
    mnesia:transaction(F).

do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

%%-------------------------------------------------------------------------
