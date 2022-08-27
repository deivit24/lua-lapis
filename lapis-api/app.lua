local lapis = require("lapis")
local respond_to = require("lapis.application").respond_to
local app = lapis.Application()

local todos = {
  {
    id = 1,
    todo = "Walk the cat",
    done = false 
  },
  {
    id = 2,
    todo = "Walk the dog",
    done = false 
  },
  {
    id = 3,
    todo = "Take out the trash",
    done = false 
  }
}

app:get("/", function()
  return { json = { todos } }
end)

app:match("/:id", function(self)
 local todo_id =  self.params.id
 for k, v in pairs(todos) do 
  if v.id == tonumber(todo_id) then 
    return {json = {todo = v}}
  end
 end

 return { json = { message = "Todo Does not exist" } }
end)

return app