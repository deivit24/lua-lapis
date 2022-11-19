local db      = require "lapis.db"
local Model   = require("lapis.db.model").Model
local Reports = Model:extend("reports", {
  relations = {
    { "post", belongs_to = "Posts" },
  }
})

Reports.valid_record = {
  { "ip", exists = true }
}
--- Prepare report for insertion
--- Create a new report
-- @tparam table params report parameters
-- @tparam table board Reports data
-- @tparam boolean op OP flag
-- @treturn boolean success
-- @treturn string error
function Reports:new(params)
  -- Check if ip already reported
  local report_exist = self:get(params.ip, params.post_id)
  print("MADE IT HERE")
  if report_exist then
    return false
  end
  -- Create report
  local report = self:create(params)
  if not report then
    return false, { "err_create_post" }
  end

  return report
end

function Reports:new_comment_report(params)
  -- Check if ip already reported
  local report_exist = self:get_by_comment_id(params.ip, params.comment_id)
  if report_exist then
    return false
  end
  -- Create report
  local report = self:create(params)
  if not report then
    return false, { "err_create_post" }
  end

  return report
end

--- Get op and last 5 posts of a thread to display on board index
-- @tparam number thread_id Thread ID
-- @treturn table posts
function Reports:get_post_reports(post_id)
  local sql = "WHERE post_id=? ORDER BY post_id desc limit 10"
  local reports = self:select(sql, post_id)
  return reports
end

--- get up to the last 5 reports of the comment
-- @tparam number comment id \
-- @treturn table treports
function Reports:get_comment_reports(comment_id)
  local sql = "WHERE comment_id=? ORDER BY comment_id desc limit 10"
  local reports = self:select(sql, comment_id)
  return reports
end

function Reports:all_reports()

  local sql = [[
    SELECT
      reports.post_id, 
      posts.subject, 
      posts.name, posts.ip,
      COUNT (reports.post_id)
    FROM
      reports, posts
    WHERE reports.post_id = posts.id AND posts.banned = false
    GROUP BY
      reports.post_id,
      posts.subject, 
      posts.name, 
      posts.ip 
    ORDER BY COUNT(reports.post_id) DESC
	]]
  local reports = db.query(sql)

  return reports
end

function Reports:all_comment_reports()

  local sql = [[
    SELECT
      reports.id,
      reports.comment_id, 
      reports.report_type,
      reports.report,
      reports.created_at,
      comments.name, 
      comments.body, comments.ip
    FROM
      reports, comments
    WHERE reports.comment_id = comments.id AND comments.banned = false
    ORDER BY reports.created_at DESC
	]]
  local reports = db.query(sql)

  return reports
end

--- Get report data by post id and ip
-- @tparam number ip IP ADDRESS
-- @tparam number post_id Local Post ID
-- @treturn table report
function Reports:get(ip, post_id)
  local report = self:find {
    post_id = post_id,
    ip      = ip
  }
  return report and report or false, nil
end

--- Get report data by comment id and ip
-- @tparam number ip IP ADDRESS
-- @tparam number comment identifier Local Comment ID
-- @treturn table report
function Reports:get_by_comment_id(ip, comment_id)
  local report = self:find {
    comment_id = comment_id,
    ip         = ip
  }
  return report and report or false, nil
end

--- Get post data
-- @tparam number id Post ID
-- @treturn table post
function Reports:get_by_ip(ip)
  local sql = "WHERE ip=? limit 100"
  local reports = self:select(sql, ip)
  return reports and reports or false, "FIXME"
end

--- Count reports on a post
-- @tparam number board_id Boards ID
-- @treturn number posts
function Reports:count_reports(post_id)
  local sql = "post_id=?"
  return self:count(sql, post_id)
end

return Reports
