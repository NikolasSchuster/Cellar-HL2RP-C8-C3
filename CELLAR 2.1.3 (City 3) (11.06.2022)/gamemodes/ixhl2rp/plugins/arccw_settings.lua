local PLUGIN = PLUGIN

if (SERVER) then
    RunConsoleCommand("arccw_override_crosshair_off", "0")
else
    RunConsoleCommand("arccw_crosshair", "1")
    RunConsoleCommand("arccw_shake", "0")
    RunConsoleCommand("arccw_vm_bob_sprint", "2.80")
    RunConsoleCommand("arccw_vm_sway_sprint", "1.85")
    RunConsoleCommand("arccw_vm_right", "1.16")
    RunConsoleCommand("arccw_vm_forward", "3.02")
    RunConsoleCommand("arccw_vm_up", "0")
    RunConsoleCommand("arccw_vm_lookxmult", "-2.46")
    RunConsoleCommand("arccw_vm_lookymult", "7")
    RunConsoleCommand("arccw_vm_accelmult", "0.85")
    RunConsoleCommand("arccw_crosshair_clr_a", "61")
    RunConsoleCommand("arccw_crosshair_clr_b", "255")
    RunConsoleCommand("arccw_crosshair_clr_g", "242")
    RunConsoleCommand("arccw_crosshair_clr_r", "0")
    RunConsoleCommand("arccw_crosshair_outline", "0")
    RunConsoleCommand("arccw_crosshair_shotgun", "1")
end