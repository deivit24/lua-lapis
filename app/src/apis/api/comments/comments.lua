local ngx                = _G.ngx
local action             = setmetatable({}, require "apis.api.internal.action_base")
local assert_error       = require("lapis.application").assert_error
local assert_valid       = require("lapis.validate").assert_valid
local trim_filter        = require("lapis.util").trim_filter
local parse_query_string = require("lapis.util").parse_query_string
local models             = require("models")
local Comments           = models.comments

function action:GET()
  local post_id = tonumber(self.params.post_id)
  local page = parse_query_string(self.req.parsed_url.query).page
  local comments = assert_error(Comments:get_post_comments(post_id, page))
  return {
    status = ngx.HTTP_OK,
    json = {
      comments = comments
    }
  }
end

function action:POST()
  local params = {
    name = self.api_user.username,
    body = self.params.body,
    post_id = self.params.post_id,
    user_id = self.api_user.id,
    created_at = os.date(),
    comment_id = self.params.comment_id,
    reply_id = self.params.reply_id
  }
  params.file_base64 = self.params.file_base64 or nil
  params.file_name = self.params.file_name or nil
  params.file_size = self.params.file_size or nil
  params.ip = self.req.headers["X-Real-IP"] or self.req.remote_addr
  trim_filter(params)
  assert_valid(params, Comments.valid_record)

  -- -- Create comment
  local comment = assert_error(Comments:new(params))

  return {
    status = ngx.HTTP_OK,
    json   = {
      comment = comment,
    }
  }
end

return action
