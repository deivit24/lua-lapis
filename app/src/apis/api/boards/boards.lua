local ngx                = _G.ngx
local action             = setmetatable({}, require "apis.api.internal.action_base")
local assert_error       = require("lapis.application").assert_error
local assert_valid       = require("lapis.validate").assert_valid
local trim_filter        = require("lapis.util").trim_filter
local parse_query_string = require("lapis.util").parse_query_string
local models             = require("models")
local role               = require "utils.role"
local Boards             = models.boards

function action:GET()
  -- Get all Todos
  local boards = assert_error(Boards:get_all(parse_query_string(self.req.parsed_url.query).popular))

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
    subtext = self.params.subtext,
    category_id = self.params.category_id,
    created_at = os.date()
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
