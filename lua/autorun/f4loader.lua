F4 = F4 or {}

local prefix = "BF4"
local rootdir = "F4"
local printer = true

F4.CONMSG = function(...)
    if printer then
        MsgC(Color(8, 241, 0), "[", Color(0, 17, 255), prefix, Color(8, 241, 0), "]", Color(0, 204, 255), ..., "\n")
    else
        return
    end
end

MsgC(Color(255, 0, 0), "[" .. prefix .. "]: LOADING", "\n")
F4.AddFile = function(File, directory)
    local prefix = string.lower(string.Left(File, 3))
    if SERVER and prefix == "sv_" then
        include(directory .. File)
        F4.CONMSG("[SV] " .. File .. " included")
    elseif prefix == "sh_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            F4.CONMSG("[SH] " .. File .. " added")
        end

        include(directory .. File)
        F4.CONMSG("[SH] " .. File .. " included")
    elseif prefix == "cl_" then
        if SERVER then
            AddCSLuaFile(directory .. File)
            F4.CONMSG("[CL] " .. File .. " included")
        elseif CLIENT then
            include(directory .. File)
            F4.CONMSG("[CL] " .. File .. " added")
        end
    end
end

F4.IncludeDir = function(directory)
    directory = directory .. "/"
    local files, directories = file.Find(directory .. "*", "LUA")
    for _, v in ipairs(files) do
        if string.EndsWith(v, ".lua") then F4.AddFile(v, directory) end
    end

    for _, v in ipairs(directories) do
        local mod = string.lower(string.Left(v, 4))
        F4.IncludeDir(directory .. v)
    end
end

F4.IncludeDir(rootdir)
MsgC(Color(255, 0, 0), "[" .. prefix .. "]: LOADED", "\n")
