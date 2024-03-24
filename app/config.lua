local config     = require "lapis.config"
local secret     = os.getenv("SECRET") or "iamaweaksecret"
-- Use rewrite rules to create 'boards.' and 'static.' subdomains
-- Currently doesn't work, leave this as false!
local subdomains = false

-- Maximum file size (update this in scripts.js too!)
local body_size  = "15m"

-- Maximum comment size (update this in scripts.js too!)
local text_size  = 10000

-- Path to your lua libraries (LuaRocks and OpenResty)
local lua_path   = "./src/?.lua;./src/?/init.lua"
local lua_cpath  = ""

-- Psql env variables
local host       = os.getenv("HOST") or "psql"
local user       = os.getenv("USER") or "postgres"
local password   = os.getenv("PASSWORD") or ""
local database   = os.getenv("DATABASE") or "lapis_db"

-- Port
local port       = os.getenv("PORT") or 9090

config("development", {
    site_name  = "[DEVELOPMENT] Lapis",
    code_cache = "on",
    port       = port,
    secret     = secret,
    subdomains = subdomains,
    body_size  = body_size,
    text_size  = text_size,
    lua_path   = lua_path,
    lua_cpath  = lua_cpath,
    postgres   = {
        host     = host,
        user     = user,
        password = password,
        database = database
    },
})

config("production", {
    code_cache = "on",
    site_name  = "Lapis-chan",
    port       = port,
    secret     = secret,
    subdomains = subdomains,
    body_size  = body_size,
    text_size  = text_size,
    lua_path   = lua_path,
    lua_cpath  = lua_cpath,
    postgres   = {
        host     = host,
        user     = user,
        password = password,
        database = database
    },
})

config("test", {
    site_name  = "[DEVEL] Lapis",
    port       = 80,
    secret     = secret,
    subdomains = subdomains,
    body_size  = body_size,
    text_size  = text_size,
    lua_path   = lua_path,
    lua_cpath  = lua_cpath,
    postgres   = {
        host     = host,
        user     = user,
        password = password,
        database = database
    },
})
