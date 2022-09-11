local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local role         = require "utils.role"
local Boards       = models.boards
local Posts        = models.posts

function action:GET()
  -- Get all Todos
  local boards = assert_error(Boards:get_all())
  for index, value in ipairs(boards) do
    value.post_count = Posts:count_posts(value.id)
    value.announcement_count = Boards:get_announcement_count(value.id)
  end
  return {
    status = ngx.HTTP_OK,
    json = {
      boards = boards
    }
  }
end

function action:POST()
  -- Validate parameters
  assert_error(role.admin(self.api_user))
  local params = {
    name = self.params.name,
    short_name = self.params.short_name,
    rules = self.params.rules,
    subtext = self.params.subtext
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
