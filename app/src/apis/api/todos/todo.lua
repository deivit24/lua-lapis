local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local yield_error  = require("lapis.application").yield_error
local models       = require "models"
local Todo         = models.todo

function action:GET()
  local todo = assert_error(Todo:get(self.params.name))

  return {
    status = ngx.HTTP_OK,
    json   = todo
  }
end

return action
