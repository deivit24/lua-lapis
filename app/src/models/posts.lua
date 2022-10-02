local db = require "lapis.db"
local Model = require("lapis.db.model").Model
local Posts = Model:extend("posts", {
  relations = {
    { "board", belongs_to = "Boards" },
  }
})

Posts.valid_record = {
  { "name", max_length = 25, exists = true },
  { "subject", max_length = 50, exists = true },
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
function Posts:get_board_posts(board_id, banned)
  local long_sql = [[
    SELECT
      p.id,
      p.name,
      p.board_id,
      p.banned,
      p.body,
      p.created_at,
      p.file_base64,
      p.file_size,
      p.lewd,
      p.subject,
      p.user_id,
      (select count(*) from comments where comments.post_id=p.id) as comment_count,
      (select count(*) from comments where comments.post_id=p.id AND comments.comment_id = 0) as parent_comment_count
    FROM posts as p
    WHERE p.board_id =]] .. board_id .. [[ AND p.]] .. banned .. [[ ORDER BY comment_count DESC LIMIT 10

  ]]

  local sql = "WHERE board_id=? AND " .. banned .. " ORDER BY id desc limit 10"
  local posts = db.query(long_sql)

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

--- Modify a Post
-- @tparam table params Post parameters
-- @tparam post_id params Post id
function Posts:modify(params, id)
  local post = self:get_post_by_id(id)
  if not post then
    return false, { "Post does not exist" } -- FIXME: wrong error message
  end

  local success, err = post:update(params)
  if not success then
    return false, "FIXME: " .. tostring(err)
  end

  return post
end

--- Get post data
-- @tparam number id Post ID
-- @treturn table post
function Posts:get_post_by_id(id)
  local post = self:find(id)
  return post and post or false, nil
end

--- Count posts in a Board
-- @tparam number board_id Boards ID
-- @treturn number posts
function Posts:count_posts(board_id)
  local sql = "board_id=?"
  return self:count(sql, board_id)
end

return Posts
