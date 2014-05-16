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
			
			NewPathName = hash_and_rename(Dir,Name,""),
			{ok,Filenames} = file:list_dir(NewPathName),
			ok = hash(Filenames,NewPathName ++ "/"),
			hash(T,Dir);
		_Else ->
			Extension = filename:extension(Name),
			hash_and_rename(Dir,Name,Extension),
			hash(T,Dir)
	end.

hash_and_rename(Dir,Name,Extension) ->
	RandomSalt = binary_to_list(crypto:rand_bytes(100)),
	<<HashName:128>> = crypto:hash(md5,RandomSalt ++ salt() ++ Name),
	NewPathName = Dir ++ integer_to_list(HashName),
	file:rename(Dir ++ Name, NewPathName ++ Extension),
	NewPathName.

	