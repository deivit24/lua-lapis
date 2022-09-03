local test_image = require("src.utils.images")
local default_rules = [[
  <ul>
    <li>SFW Board</li>
    <li>Community board (off-topic is acceptable)</li>
    <li>Be relatively nice</li>
    <li>Spoiler any lewd content</li>
  </ul>
]]

local boards = {
  {
    short_name = "lua",
    name = "Lua Programing",
    subtext = "Metatables for President",
    rules = default_rules
  },
  {
    short_name = "python",
    name = "Python Programing",
    subtext = "Complex is better than complicated.",
    rules = default_rules
  },
  {
    short_name = "js",
    name = "JavaScript",
    subtext = "If it can be written in javascript, it will be",
    rules = default_rules
  },
  {
    short_name = "c",
    name = "C",
    subtext = "The God Father",
    rules = default_rules
  },
  {
    short_name = "rust",
    name = "Rust",
    subtext = "Time to refactor the codebase",
    rules = default_rules
  },
  {
    short_name = "go",
    name = "Golang",
    subtext = "For the googlers",
    rules = default_rules
  },
  {
    short_name = "java",
    name = "Java",
    subtext = "OOP BABY!!",
    rules = default_rules
  },
  {
    short_name = "php",
    name = "PHP",
    subtext = "Please stop",
    rules = default_rules
  },
  {
    short_name = "c++",
    name = "C++",
    subtext = "Let's build a game engine",
    rules = default_rules
  },
  {
    short_name = "ts",
    name = "TypeScript",
    subtext = "I'm just JavaScript on roids",
    rules = default_rules
  }

}
local function seed(db)
  for key, value in ipairs(boards) do
    db.insert("boards", {
      short_name = value.short_name,
      name = value.name,
      subtext = value.subtext,
      rules = value.rules
    })
  end

  db.insert("posts", {
    name = "David SALAZAR",
    body = "this is a test body",
    file_base64 = test_image,
    ip = "123.123.123",
    board_id = 1
  })
  db.insert("posts", {
    name = "Anon User",
    body = "I just created a seeder for in lua for the first time",
    subject = "Hello!! Thisis is a subject",
    ip = "123.123.125",
    board_id = 1
  })


end

return seed
