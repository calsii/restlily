local ngx = require "ngx"
local shell = require "resty.shell"
local utils = require "server.utils"

local req = ngx.req
local say = ngx.say
local exit = ngx.exit
local prefix = ngx.config.prefix()

local _M = { version = "0.0.1" }

function _M.bootstrap()
    if req.get_method() ~= "POST" then
        exit(ngx.HTTP_NOT_ALLOWED)
    end

    req.read_body()
    local code = utils.get_by_key(req.get_post_args(), "code")

    if code == nil then
        exit(ngx.HTTP_NOT_ACCEPTABLE)
    end

    -- say(code)

    -- save request params to a temp file
    local temp_file = prefix .. "ly/" .. utils.random()
    local file, err = utils.write_file(temp_file .. ".ly", code)
    if not file then
        say(err)
        exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    -- run lilypond
    local ok, stdout, stderr, reason, status =
        shell.run("lilypond -o " .. temp_file .. " " .. temp_file)
    if not ok then
        say(stderr)
        exit(ngx.HTTP_NOT_ACCEPTABLE)
    end

    -- read the generated pdf
    local file, err = utils.read_file(temp_file .. ".pdf")
    if not file then
        say(err)
        exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    ngx.header.content_type = "application/pdf";
    say(file)
    -- delete temp files
    shell.run("rm -f " .. temp_file .. '.*')
    -- say("done")
    exit(ngx.HTTP_OK)
end

return _M
