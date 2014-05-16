-module(hash).
-export([run/1]).

salt() -> "THIS IS THE SALT!".

run(Dir) ->
	{ok, Filenames} = file:list_dir(Dir),
	hash(Filenames,Dir).


hash([],_Dir) -> ok;
hash([Name | T],Dir) ->
	case filelib:is_dir(Dir ++ Name) of
		true ->
			
			PathName = Dir ++ salt_and_hash(Name),
			file:rename(Dir ++ Name, PathName),
			{ok,Filenames} = file:list_dir(PathName),
			ok = hash(Filenames,PathName ++ "/"),
			hash(T,Dir);
		_Else ->
			PathName = Dir ++ salt_and_hash(Name),
			file:rename(Dir ++ Name, PathName ++ ".java"),
			hash(T,Dir)
	end.

salt_and_hash(Name) ->
	RandomSalt = binary_to_list(crypto:rand_bytes(100)),
	<<HashName:128>> = crypto:hash(md5,RandomSalt ++ salt() ++ Name),
	integer_to_list(HashName). 

	