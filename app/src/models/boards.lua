local db     = require "lapis.db"
local Model  = require("lapis.db.model").Model
local Boards = Model:extend("boards")

Boards.valid_record = {
  { "short_name", max_length = 255, exists = true },
  { "name", max_length = 255, exists = true },
  { "subtext", max_length = 255 },
  { "anon_name", max_length = 255 },
}

--- Create a board
-- @tparam table params Board parameters
-- @treturn boolean success
-- @treturn string error
function Boards:new(params)
  local board = self:create(params)
  if not board then
    return false, { "err_create_board", { params.name, params.short_name } }
  end

  return board
end

--- Modify a board
-- @tparam table params Board parameters
-- @tparam old_name Board's current short name
-- @treturn boolean success
-- @treturn string error
function Boards:modify(params, id)
  local board = self:get_by_id(id)
  if not board then
    return false, { "err_create_board", { params.name, params.short_name } } -- FIXME: wrong error message
  end

  local success, err = board:update(params)
  if not success then
    return false, "FIXME: " .. tostring(err)
  end

  return board
end

--- Delete a board
-- @tparam string name Board's short name
-- @treturn boolean success
-- @treturn string error
function Boards:delete(id)
  local board = self:get_by_id(id)
  if not board then
    return false, { "err_create_board", { id, id } } -- FIXME: wrong error message
  end

  -- Clear board
  local success = board:delete()
  return success and board or false, { "err_delete_board", { board.name, board.short_name } }
end

--- Get all boards
-- @treturn table boards
function Boards:get_all()
  local sql = [[
		select
			boards.name,
			boards.id,
			boards.short_name,
      boards.subtext,
			boards.rules
		from boards
	]]
  local boards = db.query(sql)
  return boards and boards or false, "FIXME: ALART!"
end

--- Get board data
-- @tparam string name Board's short name
-- @treturn table board
function Boards:get(name)
  local board = self:find { name = name }
  return board and board or false, "FIXME: ALART!"
end

--- Get board by id
-- @tparam number identifier
-- @treturn table todo
function Boards:get_by_id(id)
  local board = self:find(id)
  return board or nil
end

return Boards


-- Get IP from ngx
-- self.params.ip = self.req.headers["X-Real-IP"] or self.req.remote_addr
