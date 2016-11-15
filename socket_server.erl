-module(socket_server).
-export([]).

-define(Port,9000).

start_server()->
    Pid=spawn_link(fun()-> {ok,LSocket}=gen_tcp:listen(?Port,[binary,{active,false}]),  
			   spawn(fun()->acceptState(LSocket) end),
			   timer:sleep(infinity),
		   end),
    {ok,Pid}.


acceptState(LSocket)->
    
    {ok,ASocket}=gen-tcp:accept(LSocket),
    spawn(fun()->acceptState(LSocket)end),
    handler(ASocket).
