--- Yazi CWD Tracker Plugin
-- Emits OSC 7 escape sequences to inform terminal emulators of the current directory

local function url_encode(str)
    -- URL encode for file:// URLs (RFC 3986)
    return str:gsub("([^%w%-._~/%:])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

local function emit_osc7(cwd)
    local path = tostring(cwd)
    local encoded = url_encode(path)
    
    -- OSC 7 format: ESC ] 7 ; file://hostname/path BEL
    -- Write directly to /dev/tty to bypass yazi's output control
    local cmd = string.format(
        "printf '\\033]7;file://%%s%s\\007' \"$(hostname)\" > /dev/tty 2>/dev/null &",
        encoded:gsub("'", "'\\''")
    )
    
    os.execute(cmd)
end

return {
    setup = function(st, _args)
        local function update_cwd()
            local cwd = cx.active.current.cwd
            if not cwd then return end
            
            local path = tostring(cwd)
            if path ~= st.last_cwd then
                st.last_cwd = path
                emit_osc7(cwd)
            end
        end

        ps.sub("cd", update_cwd)
        ps.sub("tab", update_cwd)
        ya.sync(function()
            if cx and cx.active and cx.active.current and cx.active.current.cwd then
                update_cwd()
            end
        end)
    end,
}

