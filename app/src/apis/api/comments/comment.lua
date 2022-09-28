local ngx                = _G.ngx
local action             = setmetatable({}, require "apis.api.internal.action_base")
local assert_error       = require("lapis.application").assert_error
local assert_valid       = require("lapis.validate").assert_valid
local trim_filter        = require("lapis.util").trim_filter
local models             = require("models")
local Comments           = models.comments
local parse_query_string = require("lapis.util").parse_query_string

function action:GET()
  local post_id = tonumber(self.params.post_id)
  local comment_id = tonumber(self.params.comment_id)
  local page = parse_query_string(self.req.parsed_url.query).page
  local replies = assert_error(Comments:get_comment_replies(post_id, comment_id, tonumber(page)))
  return {
    status = ngx.HTTP_OK,
    json = {
      replies = replies
    }
  }
end

return action
