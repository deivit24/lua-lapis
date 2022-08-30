local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local trim_filter  = require("lapis.util").trim_filter
local yield_error  = require("lapis.application").yield_error
local models       = require "models"
local Todo         = models.todo

function action:GET()
  local todo = assert_error(Todo:get_by_id(self.params.id))

  return {
    status = ngx.HTTP_OK,
    json   = todo
  }
end

function action:PUT()
  local todo = assert_error(Todo:get_by_id(self.params.id))
  local params = {
    name = self.params.name,
    done = self.params.done
  }
  trim_filter(params)
  local updated_todo = assert_error(Todo:modify(params, todo.id))

  return {
    status = ngx.HTTP_OK,
    json   = {
      todo = updated_todo,
    }
  }
end

function action:DELETE()

  -- Create user
  local todo = assert_error(Todo:delete(self.params.id))

  return {
    status = ngx.HTTP_OK,
    json   = {
      todo = todo,
    }
  }
end

return action
