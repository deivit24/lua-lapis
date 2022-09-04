local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Posts        = models.posts

function action:GET()
  local board_id = tonumber(self.params.board_id)
  local posts = assert_error(Posts:get_board_posts(board_id))
  return {
    status = ngx.HTTP_OK,
    json = {
      posts = posts
    }
  }
end


return action
