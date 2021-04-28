local ngx = require "ngx"
local shell = require "resty.shell"
local utils = require "server.utils"
local template = require "resty.template"

local req = ngx.req
local say = ngx.say
local exit = ngx.exit
local prefix = ngx.config.prefix()

local _M = { version = "0.0.1" }

function _M.bootstrap()
    local method = req.get_method()

    if method == "GET" then
        template.new({ root = prefix .. "web" }).render_file("index.html")
    end

    if method ~= "POST" then
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
    shell.run("lilypond -o " .. temp_file .. " " .. temp_file)

    -- read the generated pdf
    file, err = utils.read_file(temp_file .. ".pdf")
    if not file then
        say(err)
        exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    ngx.header.content_type = "application/pdf";
    say(file)
    -- delete temp files
    shell.run("rm -f " .. temp_file .. '.*')
    exit(ngx.HTTP_OK)
end

return _M
