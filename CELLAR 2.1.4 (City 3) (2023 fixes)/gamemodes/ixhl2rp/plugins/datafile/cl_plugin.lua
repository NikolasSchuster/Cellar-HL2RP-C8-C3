local PLUGIN = PLUGIN

surface.CreateFont("MiddleLabels", {
    font = "DermaLarge",
    size = 21,
    weight = 0,
})

surface.CreateFont("TopBoldLabel", {
    font = "DermaLarge",
    size = 21,
    weight = 500,
    antialias = true,
})

surface.CreateFont("TopLabel", {
    font = "Helvetica",
    size = 23,
    weight = 0,
    antialias = true,
})

-- Remove an entry, send extra data for validation purposes.
function PLUGIN:RemoveEntry(target, key, date, category, text)
    netstream.Start("RemoveDatafileEntry", target, key, date, category, text)
end

-- Update a player their Civil Status.
function PLUGIN:UpdateCivilStatus(target, tier)
    netstream.Start("UpdateCivilStatus", target, tier)
end

function PLUGIN:UpdateRankStatus(target, tier)
    netstream.Start("UpdateRankStatus", target, tier)
end

-- A small delay is added for callback reasons. Really disgusting solution.
function PLUGIN:Refresh(target)
    netstream.Start("RefreshDatafile", target)
end
