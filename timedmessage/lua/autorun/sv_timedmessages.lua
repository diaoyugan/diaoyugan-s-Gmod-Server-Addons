if SERVER then
    local function PrintMessageA()
        PrintMessage( HUD_PRINTTALK, "<your message here>")
    end

    local function PrintMessageB()
        PrintMessage( HUD_PRINTTALK, "<your message here>")
    end

    local function PrintMessageC()
        PrintMessage( HUD_PRINTTALK, "<your message here>")
    end

    local function PrintMessageD()
        PrintMessage( HUD_PRINTTALK, "<your message here>")
    end

    local function CreateTimers( )
    	timer.Create( "timerA", 180, 0, PrintMessageA )
        timer.Create( "timerB", 190, 0, PrintMessageB )
        timer.Create( "timerC", 200, 0, PrintMessageC )
        timer.Create( "timerD", 300, 0, PrintMessageD )
    end
    hook.Add( "Initialize", "Timed Message", CreateTimers )
end