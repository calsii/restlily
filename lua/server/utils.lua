local ngx = ngx
local io_open = io.open

local _M = {}

function _M.read_file(path)
    local fp, err = io_open(path)
    if not fp then
        return nil, err
    end

    local chunk = fp:read("*all")
    fp:close()

    return chunk
end


return _M
