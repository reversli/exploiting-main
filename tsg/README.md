# exploiting/tsg

scripts for [The Survival Game](https://www.roblox.com/games/11156779721)

## tsg.lua
a script ui maintained by engo for the survival game, packed with features.

## utilities.lua
a script for developers to assist with creating survival game scripts.

### Utilities Documentation

#### Requring the script
```lua
local utilities = loadstring(game:HttpGet("https://github.com/joeengo/exploiting/blob/main/tsg/utilities.lua?raw=true"))()
```

#### Initializing the script
initalizing the script will set the `remotes` table and bypass anticheat in tsg
```lua
utilities.init()
```


#### Checking for update
Check if the utils are up to date for current server version
```lua
utilities.isUpdated()
```

example usage:

```lua
if not (utilities.isUpdated()) then 
    return -- Kick player with reason 'not updated' or such.
end
```

#### Getting remotes
get table of remotes, they are named the same as their instance counterpart. (e.g meleePlayer)
```lua
local remotes = utilities.remotes
```

example usage:
```lua
remotes.meleePlayer:FireServer(...)
```

