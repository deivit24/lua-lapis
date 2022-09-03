local lapis = require("lapis")
local app = lapis.Application()
app.include = function(self, a)
  self.__class.include(self, a, nil, self)
end

-- Basically a CORS middleware
do
  app:before_filter(
    function(self)
      self.res.headers["Access-Control-Allow-Origin"] = "*"
      self.res.headers["Access-Control-Allow-Credentials"] = true
      self.res.headers["Access-Control-Allow-Headers"] = "Authorization,Content-Type,Accept"
      self.res.headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE"
      self.res.headers["Access-Control-Expose-Headers"] = "Authorization,Content-Length,Content-Type"

      if self.req.method == "OPTIONS" then
        self.res.headers["Content-Length"] = 0
        self.res.headers["Content-Type"] = "text/plain"
        return self:write({ status = 200 })
      end
    end
  )
end
app:include("apis.api")
return app
