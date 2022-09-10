local Model = require("lapis.db.model").Model
local Posts = Model:extend("posts", {
  relations = {
    { "board", belongs_to = "Boards" },
  }
})

Posts.valid_record = {
  { "name", max_length = 255, exists = true },
  { "body", max_length = 1000, exists = true },
}
--- Prepare post for insertion
--- Create a new post
-- @tparam table params Post parameters
-- @tparam table board Board data
-- @tparam boolean op OP flag
-- @treturn boolean success
-- @treturn string error
function Posts:new(params)

  -- Create post
  local post = self:create(params)
  if not post then
    return false, { "err_create_post" }
  end

  return post
end

--- Get op and last 5 posts of a thread to display on board index
-- @tparam number thread_id Thread ID
-- @treturn table posts
function Posts:get_board_posts(board_id)

  local sql = "WHERE board_id=? ORDER BY id desc limit 10"
  local posts = self:select(sql, board_id)

  return posts
end

--- Get post data
-- @tparam number board_id Board ID
-- @tparam number post_id Local Post ID
-- @treturn table post
function Posts:get(board_id, post_id)
  local post = self:find {
    board_id = board_id,
    id       = post_id
  }
  return post and post or false, "FIXME"
end

--- Get post data
-- @tparam number id Post ID
-- @treturn table post
function Posts:get_post_by_id(id)
  local post = self:find(id)
  return post and post or false, "FIXME"
end

--- Count posts in a Board
-- @tparam number board_id Boards ID
-- @treturn number posts
function Posts:count_posts(board_id)
  local sql = "board_id=?"
  return self:count(sql, board_id)
end

return Posts
