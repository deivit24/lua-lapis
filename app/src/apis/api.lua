local lapis   = require "lapis"
local app     = lapis.Application()
local capture = require("lapis.application").capture_errors_json
local handle  = require("utils.error").handle
app.__base    = app
app.include   = function(self, a)
  self.__class.include(self, a, nil, self)
end


app:before_filter(capture({ on_error = handle, require "apis.api.internal.before_auth" }))
app:include("apis.api.core")
app:include("apis.api.todos")
app:include("apis.api.boards")
app:include("apis.api.users")
app:include("apis.api.announcements")
app:include("apis.api.reports")
app:include("apis.api.posts")

return app
