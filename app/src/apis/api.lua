local lapis   = require "lapis"
local capture = require("lapis.application").capture_errors_json
local app     = lapis.Application()
app.__base    = app
app.include   = function(self, a)
  self.__class.include(self, a, nil, self)
end

app:include("apis.api.todos")

return app
