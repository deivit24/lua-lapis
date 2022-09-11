local ngx           = _G.ngx
local action        = setmetatable({}, require "apis.api.internal.action_base")
local assert_error  = require("lapis.application").assert_error
local assert_valid  = require("lapis.validate").assert_valid
local trim_filter   = require("lapis.util").trim_filter
local models        = require("models")
local role          = require "utils.role"
local Announcements = models.Announcements


function action:POST()
  -- Validate parameters
  assert_error(role.admin(self.api_user))
  local params = {
    text = self.params.text,
    board_id = self.params.board_id,
    type = Announcements.type:to_name(self.params.type),
  }
  trim_filter(params)
  assert_valid(params, Announcements.valid_record)

  -- Create user
  local announcement = assert_error(Announcements:new(params))

  return {
    status = ngx.HTTP_OK,
    json   = {
      announcement = announcement,
    }
  }
end

return action
