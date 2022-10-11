local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local trim_filter  = require("lapis.util").trim_filter
local yield_error  = require("lapis.application").yield_error
local models       = require "models"
local Boards       = models.boards

function action:GET()
  local board = assert_error(Boards:get(self.params.id))
  board.announcements = board:get_announcements()
  return {
    status = ngx.HTTP_OK,
    json   = board
  }
end

function action:PUT()
  local board = assert_error(Boards:get_by_id(self.params.id))
  local params = {
    name = self.params.name,
    short_name = self.params.short_name,
    subtext = self.params.subtext,
    rules = self.params.rules
  }
  trim_filter(params)
  local updated_board = assert_error(Boards:modify(params, board.id))

  return {
    status = ngx.HTTP_OK,
    json   = {
      board = updated_board,
    }
  }
end

function action:DELETE()

  -- Delete board
  local board = assert_error(Boards:delete(self.params.id))

  return {
    status = ngx.HTTP_OK,
    json   = {
      success = true,
      message = "Succesfully deleted"
    }
  }
end

return action
