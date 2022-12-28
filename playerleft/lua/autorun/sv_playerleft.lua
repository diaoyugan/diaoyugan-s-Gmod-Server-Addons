if SERVER then
    hook.Add( "PlayerDisconnected", "Playerleave", function(ply)
        PrintMessage( HUD_PRINTTALK, ply:Nick().. " 离开了服务器 " )
    end )
end