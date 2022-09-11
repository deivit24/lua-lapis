local ngx           = _G.ngx
local action        = setmetatable({}, require "apis.api.internal.action_base")
local assert_error  = require("lapis.application").assert_error
local trim_filter   = require("lapis.util").trim_filter
local yield_error   = require("lapis.application").yield_error
local models        = require "models"
local Announcements = models.announcements

function action:DELETE()

  -- Delete board
  local announcement = assert_error(Announcements:delete(self.params.id))

  return {
    status = ngx.HTTP_OK,
    json   = {
      success = true,
      message = "Succesfully deleted"
    }
  }
end

return action
