local test_image    = require("src.utils.images")
local uuid          = require "resty.jit-uuid"
local default_rules = [[ SFW Board,
    Community board (off-topic is acceptable),
    Be relatively nice,
    Spoiler any lewd content
]]

local boards = {
  {
    short_name = "lua",
    name = "Lua Programing",
    subtext = "Metatables for President",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "python",
    name = "Python Programing",
    subtext = "Complex is better than complicated.",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "js",
    name = "JavaScript",
    subtext = "If it can be written in javascript, it will be",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "c",
    name = "C",
    subtext = "The God Father",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "rust",
    name = "Rust",
    subtext = "Time to refactor the codebase",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "go",
    name = "Golang",
    subtext = "For the googlers",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "java",
    name = "Java",
    subtext = "OOP BABY!!",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "php",
    name = "PHP",
    subtext = "Please stop",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "c++",
    name = "C++",
    subtext = "Let's build a game engine",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "ts",
    name = "TypeScript",
    subtext = "I'm just JavaScript on roids",
    rules = default_rules,
    category_id = 1
  },
  {
    short_name = "vue",
    name = "Vue",
    subtext = "The Progressive JavaScript Framework",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "rjs",
    name = "React",
    subtext = "It's a library not a framework...",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "ang",
    name = "Angular",
    subtext = "Googles framework",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "emb",
    name = "Ember",
    subtext = "A framework for ambitious web developers",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "sld",
    name = "Solid",
    subtext = "Simple and performant reactivity for building user interfaces",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "bkb",
    name = "Backbone",
    subtext = "JavaScript-heavy applications",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "svt",
    name = "Svelt",
    subtext = "Cybernetically enhanced web apps",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "jqy",
    name = "jQuery",
    subtext = "A feature-rich JavaScript library",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "qwk",
    name = "Qwik",
    subtext = "Framework reimagined for the edge",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "sui",
    name = "Semantic UI",
    subtext = "User Interface is the language of the web",
    rules = default_rules,
    category_id = 4
  },
  {
    short_name = "dj",
    name = "Django",
    subtext = "The web framework for perfectionists with deadlines",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "flk",
    name = "Flask",
    subtext = "Web development, one drop at a time",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "fapi",
    name = "FastAPI",
    subtext = "High performance, easy to learn",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "exp",
    name = "Express",
    subtext = "Fast, unopinionated, minimalist web framework for Node.js",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "fty",
    name = "Fastify",
    subtext = "Fast and low overhead web framework, for Node.js",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "spg",
    name = "Spring",
    subtext = "Spring make Java simple",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "lvl",
    name = "Laravel",
    subtext = "The PHP framework for web artisans",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "rail",
    name = "Ruby on Rails",
    subtext = "Compress the complexity of modern web apps",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "lap",
    name = "Lapis",
    subtext = "A web framework for lua",
    rules = default_rules,
    category_id = 3
  },
  {
    short_name = "uty",
    name = "Unity",
    subtext = "Bring your game to life",
    rules = default_rules,
    category_id = 6
  },
  {
    short_name = "rbx",
    name = "Roblox",
    subtext = "It's just Lua",
    rules = default_rules,
    category_id = 6
  },
  {
    short_name = "url",
    name = "Unreal Engine",
    subtext = "Advance 3d creation tool",
    rules = default_rules,
    category_id = 6
  },
  {
    short_name = "cry",
    name = "CryEngine",
    subtext = "Achieve Your Vision",
    rules = default_rules,
    category_id = 6
  },
  {
    short_name = "aly",
    name = "Amazon Lumberyard",
    subtext = "Open 3D Engine (O3DE)",
    rules = default_rules,
    category_id = 6
  },
  {
    short_name = "p8",
    name = "PICO-8",
    subtext = "A fantasy console for making, sharing and playing tiny games",
    rules = default_rules,
    category_id = 6
  },
  {
    short_name = "gms",
    name = "GameMaker: Studio",
    subtext = "The Ultimate 2D Game Development Environment",
    rules = default_rules,
    category_id = 6
  },

}
local function seed(db, token, bcrypt)
  db.insert("categories", {
    name = "Programming Language",
    created_at = os.date()
  })
  db.insert("categories", {
    name = "Web Development",
    created_at = os.date()
  })
  db.insert("categories", {
    name = "Backend Development",
    created_at = os.date()
  })
  db.insert("categories", {
    name = "Frontend Development",
    created_at = os.date()
  })
  db.insert("categories", {
    name = "Data Science",
    created_at = os.date()
  })
  db.insert("categories", {
    name = "Game Development",
    created_at = os.date()
  })
  for key, value in ipairs(boards) do
    db.insert("boards", {
      short_name = value.short_name,
      name = value.name,
      subtext = value.subtext,
      rules = value.rules,
      category_id = value.category_id,
      created_at = os.date()
    })
  end

  db.insert("posts", {
    name = "David SALAZAR",
    body = "this is a test body",
    subject = "Very Descriptive Subject",
    file_base64 = test_image,
    ip = "123.123.123",
    board_id = 1,
    created_at = os.date()
  })
  db.insert("posts", {
    name = "Anon User",
    body = "I just created a seeder for in lua for the first time",
    subject = "Hello!! This is is a subject",
    ip = "123.123.125",
    board_id = 1,
    created_at = os.date()
  })
  db.insert("users", {
    username = "admin",
    role = 9,
    password = bcrypt.digest("admin" .. "admin" .. token, 12),
    api_key = uuid(),
  })
  db.insert("users", {
    username = "david",
    role = 1,
    password = bcrypt.digest("david" .. "david" .. token, 12),
    api_key = uuid(),
  })
  db.insert("users", {
    username = "test_1",
    role = 1,
    password = bcrypt.digest("password" .. "password" .. token, 12),
    api_key = uuid(),
  })
  db.insert("users", {
    username = "test_2",
    role = 1,
    password = bcrypt.digest("password" .. "password" .. token, 12),
    api_key = uuid(),
  })
  db.insert("comments", {
    name = "Anon User",
    body = "Hello this is a test comment",
    ip = "123.123.124",
    post_id = 1,
    created_at = os.date()
  })
  db.insert("comments", {
    name = "Killua",
    body = "Hello this is a second commet",
    ip = "123.123.125",
    post_id = 1,
    created_at = os.date()
  })
  db.insert("announcements", {
    text = "This is an info announcement",
    type = "info",
    board_id = 1,
  })
  db.insert("announcements", {
    text = "This is an warning announcement",
    type = "warning",
    board_id = 1,
  })
  db.insert("announcements", {
    text = "This is an error announcement",
    type = "error",
    board_id = 2,
  })
end

return seed
