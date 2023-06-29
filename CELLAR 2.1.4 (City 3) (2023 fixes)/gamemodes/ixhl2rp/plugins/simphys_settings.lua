local PLUGIN = PLUGIN

if (SERVER) then
    RunConsoleCommand("sv_simfphys_gib_lifetime", "0")
    RunConsoleCommand("sv_simfphys_fuel", "0")
    RunConsoleCommand("sv_simfphys_teampassenger", "0")
    RunConsoleCommand("sv_simfphys_traction_snow", "1")
    RunConsoleCommand("sv_simfphys_damagemultiplicator", "100")
end