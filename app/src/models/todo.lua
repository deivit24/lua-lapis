local Model = require("lapis.db.model").Model
local Todo = Model:extend("todo")


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
  local todo = self:create(params)
  return todo and todo or nil, { "err_create_todo", { params.todo } }
end

--- Get Todo
-- @tparam string name Name
-- @treturn table todo
function Todo:get(name)
  local todo = self:select("where lower(name)=? limit 1", name:lower())
  return #todo == 1 and todo[1] or nil, "FIXME"
end

--- Check if unique
-- @tparam table
-- @treturn boolean success
-- @treturn string error
function Todo:is_unique(name)
  local todo = self:get(name)
  return not todo and true or nil, "FIXME", todo
end

return Todo