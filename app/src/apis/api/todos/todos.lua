local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Todo         = models.todo

function action:GET()
  -- Get all Todos
  local todos = assert_error(Todo:get_all())
  return {
    status = ngx.HTTP_OK,
    json = {
      todos = todos
    }
  }
end

function action:POST()
  -- Validate parameters
  local params = {
    name = self.params.name,
    done = false
  }
  trim_filter(params)
  assert_valid(params, Todo.valid_record)

  -- Create user
  local todo = assert_error(Todo:new(params))

  return {
    status = ngx.HTTP_OK,
    json   = {
      todo = todo,
    }
  }
end

return action
