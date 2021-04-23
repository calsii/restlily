local ngx = require "ngx"
local shell = require "resty.shell"
local utils = require "server.utils"

local req = ngx.req
local say = ngx.say
local exit = ngx.exit
local prefix = ngx.config.prefix()

local _M = {
    version = "0.0.1"
}

function _M.bootstrap()
    if req.get_method() ~= "POST" then
        exit(ngx.HTTP_NOT_ALLOWED)
    end

    req.read_body()
    local args = req.get_post_args()
    local code
    for k,v in pairs(args) do
        -- ngx.say("[POST] key:", k, " v:", v)
        if k == "code" then
            code = v
        end
    end

    if code then
    else
        exit(ngx.HTTP_NOT_ALLOWED)
    end

    say(code)

    local ok, stdout, stderr, reason, status =
        shell.run("echo " .. code .. " | lilypond - >")
    if not ok then
        say(stderr)
        exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    -- save request params to a temp file
    -- run lilypond
    -- read the generated pdf
    local file, err = utils.read_file(prefix .. "ly/bcdefg.pdf")
    if not file then
        say(err)
        exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    -- ngx.header.content_type = "application/pdf";
    -- say(file)
    -- delete temp files
    say("done")
end

return _M
