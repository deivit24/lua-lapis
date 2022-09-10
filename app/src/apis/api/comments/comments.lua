local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local models       = require("models")
local Comments     = models.comments

function action:GET()
  local post_id = tonumber(self.params.post_id)
  local comments = assert_error(Comments:get_post_comments(post_id))
  return {
    status = ngx.HTTP_OK,
    json = {
      comments = comments
    }
  }
end

function action:POST()
  -- Validate parameters
  local name = "Anon User"
  if self.params.name then
    name = self.params.name
  end
  local params = {
    name = name,
    body = self.params.body,
    post_id = self.params.post_id,
    created_at = os.date()
  }
  params.ip = self.req.headers["X-Real-IP"] or self.req.remote_addr
  trim_filter(params)
  assert_valid(params, Comments.valid_record)

  -- -- Create user
  local comment = assert_error(Comments:new(params))

  return {
    status = ngx.HTTP_OK,
    json   = {
      comment = comment,
    }
  }
end

return action
