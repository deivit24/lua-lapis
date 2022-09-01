local Model = require("lapis.db.model").Model
local Todo = Model:extend("todo")


Todo.valid_record = {
  { "name", exists = true },
}

--- Get all users
-- @treturn table users List of users
function Todo:get_all()
  local todos = self:select("order by name asc")
  return todos
end

--- Create a new todo
-- @tparam table todo Tser data
-- @treturn boolean success
-- @treturn string error
function Todo:new(params)
  -- Check if todo is unique
  do
    local unique, err = self:is_unique(params.name)
    if not unique then return nil, err end
  end
  -- create todo
  params.created = os.time()
  local todo = self:create(params)
  return todo and todo or nil, { "err_create_todo", { params.todo } }
end

-- Get Todo name
-- @tparam string name Name
-- @treturn table todo
function Todo:get(name)
  local todo = self:select("where lower(name)=? limit 1", name:lower())
  return #todo == 1 and todo[1] or nil
end

--- Get Todo by id
-- @tparam number identifier
-- @treturn table todo
function Todo:get_by_id(id)
  local todo = self:find(id)
  return todo or nil
end

--- Check if unique
-- @tparam table
-- @treturn boolean success
-- @treturn string error
function Todo:is_unique(name)
  local todo = self:get(name)
  local err = {}
  err.message = "Todo already exists"
  return not todo and true or nil, err, todo
end

--- Update todo
-- @tparam table todo Todo data
-- @treturn boolean success
-- @treturn string error
function Todo:modify(params, id)
  local todo = self:get_by_id(id)
  if not todo then return nil, "" end
  params.edited = os.time()
  local success, err = todo:update(params)
  return success and todo or nil, "FIXME: " .. tostring(err)
end

--- Delete todo
-- @tparam table todo Todo data
-- @treturn boolean success
-- @treturn string error
function Todo:delete(id)
  local todo = self:get_by_id(id)
  if not todo then
    return nil, "FIXME"
  end

  local success = todo:delete()
  return success or nil, "FIXME"
end

return Todo
