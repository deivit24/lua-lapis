local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
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

return action
