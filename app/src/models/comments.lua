local db = require "lapis.db"
local Model = require("lapis.db.model").Model
local Comments = Model:extend("comments", {
  relations = {
    { "post", belongs_to = "Posts" },
  }
})

Comments.valid_record = {
  { "body", max_length = 255, exists = true },
}

function Comments:new(params)

  -- Create post
  local comment = self:create(params)
  if not comment then
    return false, { "err_create_comment" }
  end

  return comment
end

--- Get op and last 5 posts of a thread to display on board index
-- @tparam number thread_id Thread ID
-- @treturn table posts
function Comments:get_post_comments(post_id)
  local long_sql = [[
		SELECT
			c.name,
			c.id,
			c.comment_id,
      c.reply_id,
			c.post_id,
      c.created_at,
      c.user_id,
      c.body,
      (select count(*) from comments where comment_id=c.id and c.comment_id = 0 ) as reply_count
		FROM comments c
    WHERE c.post_id = ]] .. post_id .. [[
    GROUP BY
    c.name,
			c.id,
			c.comment_id,
      c.reply_id,
			c.post_id,
      c.created_at,
      c.user_id,
      c.body ORDER BY reply_count DESC, id DESC LIMIT 20]]
  local sql = " count(comments.comment_id) as mycount WHERE post_id=? ORDER BY id desc limit 10"
  local comments = db.query(long_sql)

  return comments
end

--- Get post data
-- @tparam number board_id Board ID
-- @tparam number post_id Local Post ID
-- @treturn table post
function Comments:get(post_id, comment_id)
  local comment = self:find {
    post_id = post_id,
    id      = comment_id
  }
  return comment and comment or false, "FIXME"
end

--- Get post data
-- @tparam number id Post ID
-- @treturn table post
function Comments:get_post_by_id(id)
  local comment = self:find(id)
  return comment and comment or false, "FIXME"
end

return Comments
