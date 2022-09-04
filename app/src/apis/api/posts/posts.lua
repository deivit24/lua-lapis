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

function action:POST()
  -- Validate parameters
  local params = {
    name = self.params.name,
    body = self.params.body,
    subject = self.params.subject,
    file_base64 = self.params.file_base64 or nil,
    file_name = self.params.file_name or nil,
    file_size = self.params.file_size or nil,
    board_id = self.params.board_id,
    created_at = os.date()
  }
  params.ip = self.req.headers["X-Real-IP"] or self.req.remote_addr
  trim_filter(params)

  -- -- Create user
  local post = assert_error(Posts:new(params))

  return {
    status = ngx.HTTP_OK,
    json   = {
      post = post,
    }
  }
end

return action
