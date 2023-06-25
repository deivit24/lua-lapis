# Lua Lapis Vue LLUV Stack

## NOTES

First attempt at trying Lapis

[Lapis](https://leafo.net/lapis/)

I am on an M1 MAC and struggled to get a working version locally with luarocks.

Ended up using a docker image to get lapis to work

## REQUIREMENTS

- docker
- docker-compose

## BASIC USAGE

### Create .env file

First you must create a `.env` file from the root

run:

```shell
touch .env
```

Paste this to the `.env` file:

```
LAPIS_CONFIG=development
SECRET=CHANGE_ME
HOST=psql
USER=postgres
PASSWORD=CHANGE_ME
DATABASE=lapis_db
PORT=9090
```

The secret token should be a random string of characters between 40 and 60 characters in length. Change CHANGE_ME to your secret token. Keep this token extremely safe, it is the backbone of security on Lapis! Right now it's a simple todo app but anyone can build on this whenever you want to start adding authentication. Doesn't do anything for now. Samething for the password

from root run:
`source dev.sh`

go to `localhost:9090`

## Credit

A lot of credit goes to: [Lapchan] https://github.com/karai17/lapis-chan for alot of the code in the backend
