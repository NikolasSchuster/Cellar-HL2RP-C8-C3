--- RIFLE SHARED ---

sound.Add( {
    name = "ArcCW_WAW.Rifle_RingOff",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_dist/waw_rifle.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Sniper_RingSt",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_dist/waw_sniper_st.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.SVT_RingOff",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_dist/waw_svt40.wav",
    }
} )

--- Garand Main ---

sound.Add( {
    name = "ArcCW_WAW.Garand_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_Mech2",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/mech_last.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_Close",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/close.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_Pull",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_garand/pull.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Garand_Ping",
    channel = CHAN_USER_BASE + 1,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_garand/ping.wav",
    }
} )

-- SVT-40 MAIN --

sound.Add( {
    name = "ArcCW_WAW.SVT_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_svt40/fire_v2.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.SVT_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_svt40/mech.wav",
    }
} )

-- Gewehr 43 Main --

sound.Add( {
    name = "ArcCW_WAW.G43_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_Sil",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/sil.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_Tap",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/tap.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_Back",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/back.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.G43_Fwd",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_g43/fwd.wav",
    }
} )

-- M1 CARBINE MAIN --

sound.Add( {
    name = "ArcCW_WAW.Carbine_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_carbine/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Carbine_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_carbine/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Carbine_Futz",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_carbine/futz.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Carbine_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_carbine/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Carbine_Mech",
    channel = CHAN_USER_BASE + 6,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_carbine/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Carbine_Charge",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_carbine/charge.wav",
    }
} )

-- KAR98K Main --

sound.Add( {
    name = "ArcCW_WAW.K98_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/mono_00.wav",
        "^weapons/arccw/waw_kar98k/mono_01.wav",
        "^weapons/arccw/waw_kar98k/mono_02.wav",
        "^weapons/arccw/waw_kar98k/mono_03.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Mech",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Ringoff",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/ringoff.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Up",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/up.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Back",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/back.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Fwd",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/fwd.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Rechamber",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/rechamber.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Eject",
    channel = CHAN_USER_BASE + 1,
    volume = 0.5,
    level = 20,
    sound = {
        "^weapons/arccw/waw_kar98k/clip_eject.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.K98_Bullet",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_kar98k/in1.wav",
        "^weapons/arccw/waw_kar98k/in2.wav",
    }
} )

-- Springfield --

sound.Add( {
    name = "ArcCW_WAW.Springfield_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_springfield/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Springfield_Mech",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_springfield/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Springfield_FireSnp",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_springfield/fire_snp.wav",
    }
} )

-- ARISAKA --

sound.Add( {
    name = "ArcCW_WAW.Arisaka_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_Mech",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_FireSnp",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/fire_sniper.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_MechSnp",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/mech_sniper.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_Up",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/up.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_Down",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/down.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_Back",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/back.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_Fwd",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/fwd.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Arisaka_Insert",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_arisaka/in.wav",
    }
} )

-- MOSIN Main --

sound.Add( {
    name = "ArcCW_WAW.Mosin_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/mono_00.wav",
        "^weapons/arccw/waw_mosin/mono_01.wav",
        "^weapons/arccw/waw_mosin/mono_02.wav",
        "^weapons/arccw/waw_mosin/mono_03.wav",
    }
} )
sound.Add( {
name = "ArcCW_WAW.Mosin_Ringoff",
channel = CHAN_WEAPON,
volume = 1.0,
level = 100,
sound = {
    "^weapons/arccw/waw_mosin/ringoff.wav",
}
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Mech",
    channel = CHAN_USER_BASE + 6,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Up",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/up.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Back",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/back.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Fwd",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/fwd.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Rechamber",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/rechamber.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Eject",
    channel = CHAN_USER_BASE + 1,
    volume = 0.5,
    level = 20,
    sound = {
        "^weapons/arccw/waw_mosin/eject.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Mosin_Bullet",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_mosin/bullet.wav",
    }
} )

-- PTRS-41 MAIN --

sound.Add( {
    name = "ArcCW_WAW.PTRS_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/fire_stereo.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_Mech",
    channel = CHAN_USER_BASE + 6,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_Mech2",
    channel = CHAN_USER_BASE + 6,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/mech_last.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_Open",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/open.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_Close",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/close.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_Pull",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/pull.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PTRS_Release",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    sound = {
        "^weapons/arccw/waw_ptrs41/release.wav",
    }
} )

--- StG-44 ---

sound.Add( {
    name = "ArcCW_WAW.STG44_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/waw/fire_r.wav",
    }
} )
sound.Add( {
    name = "ArcCW_BO3.STG44_DOD",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/stg44_dod_fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.STG44_Mech",
    channel = CHAN_USER_BASE,
    volume = 0.75,
    level = 70,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/waw/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.STG44_MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/waw/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.STG44_Futz",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/waw/futz.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.STG44_MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/waw/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.STG44_Charge",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_stg44/waw/charge.wav",
    }
} )

-- WAW SHOTGUNS --

-- DOUBLE BARREL MAIN --

sound.Add( {
    name = "ArcCW_WAW.DBS_Fire",
    channel = CHAN_STATIC,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_dbshot_st_f.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.SawnOff_Fire",
    channel = CHAN_STATIC,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_dbsawshot_st_f.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Mech",
    channel = CHAN_USER_BASE + 2,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_dbshot_st_act.wav",
    }
} )

sound.Add( {
    name = "ArcCW_WAW.DBS_Click",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_click.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Break",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_break.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Shake",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shake.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_1Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shake_1brl.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Shell1",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shell_in_1.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Shell2",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_shell_in_2.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DBS_Close",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/gr_dbshot_close.wav",
    }
} )

-- TRENCH GUN MAIN --

sound.Add( {
    name = "ArcCW_WAW.TrenchGun_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_shtgun_st_f.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Trenchgun_Mech",
    channel = CHAN_USER_BASE + 2,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/wpn_shtgun_st_act.wav",
    }
} )

sound.Add( {
    name = "ArcCW_WAW.Trenchgun_Shell",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/shotgun_shell_00.wav",
        "^weapons/arccw/waw_shotgun/shotgun_shell_01.wav",
        "^weapons/arccw/waw_shotgun/shotgun_shell_02.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Trenchgun_Pull",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/shotgun_pull.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Trenchgun_Push",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_shotgun/shotgun_push.wav",
    }
} )

-- WAW RIFLE GRENADE --

sound.Add( {
    name = "ArcCW_WAW.RGren_Click",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_rifgren/click.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.RGren_Futz",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_rifgren/futz.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.RGren_Load",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_rifgren/load.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.RGren_Remove",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_rifgren/remove.wav",
    }
} )

-- Type 99 Main -- 

sound.Add( {
    name = "ArcCW_WAW.Type99_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type99/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type99_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type99/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type99_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type99/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type99_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type99/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type99_Charge",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type99/charge.wav",
    }
} )

-- DP28 Main -- 

sound.Add( {
    name = "ArcCW_WAW.DP28_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dp28/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DP28_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dp28/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DP28_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dp28/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DP28_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dp28/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DP28_Tap",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dp28/tap.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.DP28_Land",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dp28/land.wav",
    }
} )

-- BAR Main --

sound.Add( {
    name = "ArcCW_WAW.BAR_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_bar/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.BAR_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_bar/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.BAR_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_bar/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.BAR_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_bar/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.BAR_Tap",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_bar/tap.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.BAR_Charge",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_bar/charge.wav",
    }
} )

-- FG 42 main --

sound.Add( {
    name = "ArcCW_WAW.FG42_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.FG42_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.FG42_In",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.FG42_Out",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.FG42_Futz",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/futz.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.FG42_Back",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/back.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.FG42_Fwd",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_fg42/fwd.wav",
    }
} )

--- BROWNING M1919 ---

sound.Add( {
    name = "ArcCW_WAW.M1919_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_BeltContact",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/b_contact.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_BeltGrab",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/b_grab.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_BeltPress",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/b_press.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_BeltRaise",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/b_raise.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_BeltRemove",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/b_remove.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_BeltToss",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/b_toss.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_Bonk",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/bonk.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_Charge",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/charge.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_Close",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/close.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_Open",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/open.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.M1919_Start",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_m1919/start.wav",
    }
} )

--- MG42 Main ---

sound.Add( {
    name = "ArcCW_WAW.MG42_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mg42/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MG42_MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mg42/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MG42_Jimmy",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mg42/jimmy.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MG42_MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mg42/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MG42_Charge",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mg42/charge.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MG42_Pull",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mg42/pull.wav",
    }
} )

--- MP40 Main ---

sound.Add( {
    name = "ArcCW_WAW.MP40_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mp40/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MP40_Mech",
    channel = CHAN_USER_BASE,
    volume = 0.5,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mp40/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MP40_MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mp40/mag_in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MP40_MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mp40/mag_out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.MP40_Bolt",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_mp40/charge.wav",
    }
} )

--- MP40 Main ---

sound.Add( {
    name = "ArcCW_WAW.Type100_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type100_Sup",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/sup.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type100_Mech",
    channel = CHAN_USER_BASE,
    volume = 0.5,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type100_MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type100_MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type100_Tap",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/tap.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Type100_Bolt",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_type100/charge.wav",
    }
} )

--- Thompson Main ---

sound.Add( {
    name = "ArcCW_WAW.Thompson_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_thompson/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Thompson_MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_thompson/in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Thompson_MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_thompson/out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Thompson_Bolt",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_thompson/charge.wav",
    }
} )

--- PPSh-41 Main ---

sound.Add( {
    name = "ArcCW_WAW.PPSh_Fire",
    channel = CHAN_STATIC,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_ppsh/fire_mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PPSh_Mech",
    channel = CHAN_USER_BASE,
    volume = 1,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_ppsh/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PPSh_Dist",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_dist/waw_ppsh_dist.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PPSh_MagIn",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_ppsh/mag_in.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PPSh_MagTap",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_ppsh/mag_tap.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PPSh_MagOut",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_ppsh/mag_out.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.PPSh_Bolt",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_ppsh/bolt_fwd.wav",
    }
} )


-- WAW PISTOLS --
sound.Add( {
    name = "ArcCW_WAW.M1911_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {"^weapons/arccw/bo1_m1911/fire_waw.wav"}
} )
sound.Add( {
    name = "ArcCW_WAW.M1911_RingOff",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {"^weapons/arccw/bo1_m1911/ringoff_waw.wav"}
} )

sound.Add( {
    name = "ArcCW_WAW.TT33_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_tt33/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.TT33_RingOff",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_tt33/fire_dist.wav",
    }
} )

-- P38 MAIN ---

sound.Add({
    name = "ArcCW_WAW.P38_Fire",
    channel = CHAN_STATIC,
    level = 100,
    sound = "^weapons/arccw/waw_p38/fire.wav"
})
sound.Add({
    name = "ArcCW_WAW.P38_In",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_p38/in.wav"
})

sound.Add({
    name = "ArcCW_WAW.P38_Out",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_p38/out.wav"
})

sound.Add({
    name = "ArcCW_WAW.P38_Slide",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_p38/slide.wav"
})

sound.Add({
    name = "ArcCW_WAW.P38_Fusion",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = "^weapons/arccw/pap/fusion.wav"
})

-- SW Model 27 main --

sound.Add( {
    name = "ArcCW_WAW.357_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_357/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.357_Dist",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_357/dist.wav",
    }
} )

-- WAW LAUNCHERS --

sound.Add( {
    name = "ArcCW_WAW.Launcher_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/fire.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Woosh",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/front_00.wav",
        "^weapons/arccw/waw_launchers/front_01.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Mech",
    channel = CHAN_USER_BASE,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/mech.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Down",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/down.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Ground",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/ground.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Start",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/start.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Tap",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/tap.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Up",
    channel = CHAN_ITEM,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/up.wav",
    }
} )
sound.Add( {
    name = "ArcCW_WAW.Launcher_Impact",
    channel = CHAN_USER_BASE + 5,
    volume = 1.0,
    level = 100,
    ----pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_launchers/blast.wav",
    }
} )

-- WUNDERWAFFE DG2 --

sound.Add({
    name = "ArcCW_BO1.DG2_Fire",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = "^weapons/arccw/waw_dg2/fire.wav"
})
sound.Add({
    name = "ArcCW_BO1.DG2_Last",
    channel = CHAN_STATIC,
    level = 80,
    sound = "^weapons/arccw/waw_dg2/last.wav"
})
sound.Add({
    name = "ArcCW_BO1.DG2_In",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/in.wav"
})

sound.Add({
    name = "ArcCW_BO1.DG2_Out",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/out.wav"
})

sound.Add({
    name = "ArcCW_BO1.DG2_Back",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/bback.wav"
})

sound.Add({
    name = "ArcCW_BO1.DG2_Fwd",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/bfwd.wav"
})

sound.Add({
    name = "ArcCW_BO1.DG2_On",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/on.wav"
})

sound.Add({
    name = "ArcCW_BO1.DG2_Off",
    channel = CHAN_ITEM,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/off.wav"
})

sound.Add({
    name = "ArcCW_BO1.DG2_Impact",
    channel = CHAN_USER_BASE + 5,
    level = 70,
    sound = "^weapons/arccw/waw_dg2/splash.wav"
})

--- WAW ZOMBIE --

sound.Add({
    name = "ArcCW_WAW.Zombie_Attack",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_zombie/attack/0.wav",
        "^weapons/arccw/waw_zombie/attack/1.wav",
        "^weapons/arccw/waw_zombie/attack/2.wav",
        "^weapons/arccw/waw_zombie/attack/3.wav",
        "^weapons/arccw/waw_zombie/attack/4.wav",
        "^weapons/arccw/waw_zombie/attack/5.wav",
        "^weapons/arccw/waw_zombie/attack/6.wav",
        "^weapons/arccw/waw_zombie/attack/7.wav",
        "^weapons/arccw/waw_zombie/attack/8.wav",
    }
})

sound.Add({
    name = "ArcCW_WAW.Zombie_Draw",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_zombie/behind_03.wav",
    }
})


sound.Add({
    name = "ArcCW_WAW.Zombie_FirstDraw",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 100,
    --pitch = {95, 110},
    sound = {
        "^weapons/arccw/waw_zombie/behind_04.wav",
    }
})