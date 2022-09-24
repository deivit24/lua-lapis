local Model = require("lapis.db.model").Model
local Categories = Model:extend("categories")


Categories.valid_record = {
  { "name", exists = true },
}

--- Get all users
-- @treturn table users List of users
function Categories:get_all()
  local categories = self:select("order by name asc")
  return categories
end

return Categories
