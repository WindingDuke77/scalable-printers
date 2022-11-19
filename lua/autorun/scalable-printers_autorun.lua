// This Addon was created by:
// Neural Studios
//
// any questions, please contact Bob Bobington#2947

local function LoadAllFiles(dir)
    local files, dirs = file.Find( dir .. "/*", "LUA" )
    for k, v in pairs( files ) do
        if string.find(dir, "/client") then
            if SERVER then AddCSLuaFile( dir .. "/" .. v ) end
            if CLIENT then include( dir .. "/" .. v ) end
            MsgC(Color(255,217,0), "[scalableprinters]: Added " .. v .. "\n")
        elseif string.find(dir, "/server") then
            if SERVER then include( dir .. "/" .. v ) MsgC(Color(0,162,255), "[scalableprinters]: Added " .. v .. "\n") end
        elseif string.find(dir, "/shared") then
            if SERVER then AddCSLuaFile( dir .. "/" .. v ) include( dir .. "/" .. v ) end
            if CLIENT then include( dir .. "/" .. v ) end
            MsgC(Color(195,0,255), "[scalableprinters]: Added " .. v .. "\n")
        elseif string.find(dir, "scalableprinters") then
            if SERVER then AddCSLuaFile( dir .. "/" .. v ) include( dir .. "/" .. v ) end
            if CLIENT then include( dir .. "/" .. v ) end
            MsgC(Color(195,0,255), "[scalableprinters]: Added " .. v .. "\n")
        end
    end
    for k, v in pairs( dirs ) do
       if string.find(v, "module") then return end
       if string.find(v, "plugins") then return end
       LoadAllFiles( dir .. "/" .. v )
    end
    
end

LoadAllFiles("scalableprinters")
