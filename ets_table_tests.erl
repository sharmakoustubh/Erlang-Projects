-module(ets_table_tests).
-export([]).
-include_lib("eunit/include/eunit.hrl").

ets_table1_test_() ->
    {setup,
     fun setup/0,
     fun cleanup/1,
     [fun check_that_table_is_created/0,
      fun insert_non_existing_key/0,
      fun insert_already_existing_key/0,
      fun get_value_of_existing_key/0,
      fun when_key_does_not_exists/0,
      fun delete_an_entry/0,
      fun transform_an_entry/0,
      fun transform_with_bad_function/0,
      fun delete_non_existing_entry/0,
      fun transform_with_non_existing_key_function/0,
      fun delete_the_table/0]}.

check_that_table_is_created() ->
    ?assertNotEqual(undefined,ets:info(table)).	
       
insert_non_existing_key() ->
    database!{set,5,e,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(inserted, R),
    ?assertEqual(ets:lookup(table,5),[{5,e}]).

insert_already_existing_key() ->
    database!{set,1,f,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(inserted, R), 
    ?assertEqual(ets:lookup(table,1),[{1,f}]).

get_value_of_existing_key()->
    database!{get,2,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(R,b).

when_key_does_not_exists()->
    database!{get,9,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(R,{error, "key does not exist"}).

delete_an_entry()->
    database!{delete,3,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(deleted, R), 
    ?assertNotEqual(ets:lookup(table,3),[{3,c}]).

delete_non_existing_entry()->
    database!{delete,8,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(deleted, R).

transform_an_entry()->
    Tranform_function = fun(X)->
				atom_to_list(X)++"transform append"
			end,
    database!{transform,2,Tranform_function,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual(transformed,R), 
    ?assertEqual([{2,"btransform append"}],ets:lookup(table,2)).

transform_with_bad_function()->
    Tranform_function = fun(X)->
				atom_to_list(X)++"transform append"
			end,
    database!{transform,4,Tranform_function,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual({error,"function not implementable"},R). 

transform_with_non_existing_key_function()->
    Tranform_function = fun(X)->
				atom_to_list(X)++"transform append"
			end,
    database!{transform,15,Tranform_function,self()},
    R = receive
	    Resp ->
		Resp
	after 100 ->
		failed
	end,
    ?assertEqual({error,"key does not exist"},R).

delete_the_table()->
    database!deletetable,
    ?assertNotEqual(ets:lookup(table,1),[{1,a}]),
    ?assertNotEqual(ets:lookup(table,2),[{2,b}]),
    ?assertNotEqual(ets:lookup(table,3),[{3,c}]).

setup()->
    ets_table1:start(),
    timer:sleep(50),
    database!{set,1,a,self()},
    database!{set,2,b,self()},
    database!{set,3,c,self()},
    database!{set,4,1000,self()}.

cleanup(_)->
    database!deletetable,
    exit(whereis(database),kill).
