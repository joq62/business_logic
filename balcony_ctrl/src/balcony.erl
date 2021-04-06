%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc : represent a logical vm  
%%% 
%%% Supports the system with standard erlang vm functionality, load and start
%%% of an erlang application (downloaded from git hub) and "dns" support 
%%% 
%%% Make and start the board start SW.
%%%  boot_service initiates tcp_server and l0isten on port
%%%  Then it's standby and waits for controller to detect the board and start to load applications
%%% 
%%%     
%%% -------------------------------------------------------------------
-module(balcony). 

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%
%% --------------------------------------------------------------------
-define(INIT_TEMP,25).
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state,{}).

	  
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================


%% server interface

-export([read/0,
	 increase/0,
	 decrease/0,
	 reset/0
	]).

-export([
	 ping/0	 
	]).




-export([start/0,
	 stop/0
	 ]).
%% internal 
%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================


       
%% Gen server function

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).


%%----------------------------------------------------------------------
read()->
    gen_server:call(?MODULE,{read},infinity).
increase()->
    gen_server:call(?MODULE,{increase},infinity).
decrease()->
    gen_server:call(?MODULE,{decrease},infinity).
reset()->
    gen_server:call(?MODULE,{reset},infinity).

    
ping()->
    gen_server:call(?MODULE,{ping},infinity).

%%___________________________________________________________________



%%-----------------------------------------------------------------------


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    mnesia:start(),
    ok=db_balcony:create_table(),
    {atomic,ok}=db_balcony:create(my_balcony,?INIT_TEMP),
    {ok, #state{}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------

handle_call({ping}, _From, State) ->
    Reply={pong,node(),?MODULE},
    {reply, Reply, State};


handle_call({read}, _From, State) ->
    Reply=db_balcony:read(my_balcony),
    {reply, Reply, State};

handle_call({increase}, _From, State) ->
    NewTemp=db_balcony:read(my_balcony)+1,
    db_balcony:update(my_balcony,NewTemp),
    Reply=NewTemp,
    {reply, Reply,State};

handle_call({decrease}, _From, State) ->
    NewTemp=db_balcony:read(my_balcony)-1,
    db_balcony:update(my_balcony,NewTemp),
    Reply=NewTemp,
    {reply, Reply,State};

handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,?LINE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_cast({glurk}, State) ->

    {noreply, State};

handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------
