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
-module(balcony_unit_test). 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
	  
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% 
%% 
%% --------------------------------------------------------------------

% Single Mnesia 
start_test()->	  
    ?assertEqual(ok,application:start(balcony)),
    ?assertEqual(25,balcony:read()),
    ?assertEqual(26,balcony:increase()),
    ?assertEqual(27,balcony:increase()),
    ?assertEqual(26,balcony:decrease()),
    ok.

stop_test()->
    init:stop().
