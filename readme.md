# Lua Lapis

## NOTES

First attempt at trying Lapis

[Lapis](https://leafo.net/lapis/)

I am on an M1 MAC and struggled to get a working version locally with luarocks.

Ended up using a docker image to get lapis to work

## REQUIREMENTS

- docker
- docker-compose

## BASIC USAGE

### Create tokens

create a token.lua file in `data/secrets` directory

add:

```lua
local token = "CHANGE_ME"

return token
```

The secret token should be a random string of characters between 40 and 60 characters in length. Change CHANGE_ME to your secret token. Keep this token extremely safe, it is the backbone of security on Lapis! Right now it's a simple todo app but anyone can build on this whenever you want to start adding authentication. Doesn't do anything for now.

from root run:
`source dev.sh`

go to `localhost:9090`
