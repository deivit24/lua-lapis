local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Boards       = models.boards

function action:GET()
  -- Get all Todos
  local boards = assert_error(Boards:get_all())
  return {
    status = ngx.HTTP_OK,
    json = {
      boards = boards
    }
  }
end

function action:POST()
  -- Validate parameters
  local params = {
    name = self.params.name,
    short_name = self.params.short_name
  }
  trim_filter(params)
  assert_valid(params, Boards.valid_record)

  -- Create user
  local board = assert_error(Boards:new(params))

  return {
    status = ngx.HTTP_OK,
    json   = {
      board = board,
    }
  }
end

return action
