local ngx          = _G.ngx
local action       = setmetatable({}, require "apis.api.internal.action_base")
local assert_error = require("lapis.application").assert_error
local assert_valid = require("lapis.validate").assert_valid
local trim_filter  = require("lapis.util").trim_filter
local role         = require "utils.role"
local models       = require("models")
local Posts        = models.posts

function action:GET()
  local post_id = tonumber(self.params.id)
  local post = assert_error(Posts:get_post_by_id(post_id))
  return {
    status = ngx.HTTP_OK,
    json = {
      post = post
    }
  }
end

function action:PUT()
  assert_error(role.admin(self.api_user))
  local post_id = tonumber(self.params.id)
  local params = {
    banned = self.params.banned,
  }
  trim_filter(params)
  local post = assert_error(Posts:modify(params, post_id))
  return {
    status = ngx.HTTP_OK,
    json = {
      post = post
    }
  }
end

return action
