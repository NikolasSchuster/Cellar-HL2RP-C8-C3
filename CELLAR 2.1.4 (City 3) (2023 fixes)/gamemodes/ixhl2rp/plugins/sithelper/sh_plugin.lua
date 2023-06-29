local PLUGIN = PLUGIN

PLUGIN.name = "Sit Helper"
PLUGIN.author = "Zombine"
PLUGIN.description = "Adds a console command to show a graphical helper for sitting in chairs."

PLUGIN.sitMins = Vector(-5, -5, 0);
PLUGIN.sitMaxs = Vector(5, 5, 2);

PLUGIN.OBB = {
	[0] = {Vector(-5, -5, 0), Vector(5, 5, 2)},
	[7] = {Vector(-18, -18, 0), Vector(18, 18, 36)},
	[9] = {Vector(-5, -5, 0), Vector(5, 5, 32)},
}
PLUGIN.OBBF = {
	[7] = {Vector(-5, -5, 0), Vector(5, 5, 2)},
}

PLUGIN.sitStances = {
	"stances_sit01",
	"stances_sit02",
	"stances_sit03",
	"stances_sit04",
	"stances_sit05",
	"stances_sit06",
	"stances_sit07",
	"stances_sitground",
	"stances_sitwall",
	"stances_sit08",
	"stances_sit09",
	"stances_check",
	"stances_lean01",
	"stances_lean02",
	"stances_down01",
	"stances_down02",
	"stances_down03",
	"stances_arrest",
	"stances_stand01",
	"stances_stand02",
	"stances_stand03",
};

PLUGIN.sitOffsets = {
	Vector(20, 0, -19),
	Vector(20, 0, -19),
	Vector(20, 0, -19),
	Vector(20, 0, -19),
	Vector(20, 0, -19),
	Vector(20, 0, -19),
	Vector(0, 0, 0),
	Vector(12, 0, 0),
	Vector(12, 0, 0),
	Vector(20, 0, 0),
	Vector(20, 0, 0),
	Vector(0, 0, 0),
	Vector(18, 0, 0),
	Vector(12, 0, 0),
	Vector(0, 0, 0),
	Vector(0, 0, 0),
	Vector(0, 0, 0),
	Vector(0, 0, 0),
	Vector(0, 0, 0),
	Vector(0, 0, 0),
	Vector(0, 0, 0),
};

PLUGIN.sitOffsetsF = {
	[7] = Vector(20, 0, -19)
};

function PLUGIN:CanSit(player, pos, option, character)
	local obb = self.OBB[option] or self.OBB[0]

	if character and character:GetGender() == GENDER_FEMALE then
		obb = self.OBBF[option] or obb
	end

	local sitTrace = util.TraceHull({
		start = pos + Vector(0, 0, 3),
		endpos = pos,
		filter = function(ent)
			if (ent == player or ent:IsWeapon()) then
				return false;
			else
				return true;
			end;
		end,
		mins = obb[1],
		maxs = obb[2]
	});

	if (sitTrace.AllSolid) then
		return false;
	end;

	local norm = (pos - player:EyePos()):GetNormalized();

	local visTrace = util.TraceLine({
		start = player:EyePos(),
		endpos = pos - norm * 2,
		filter = player,
	});

	if (visTrace.Hit) then
		return false;
	end;

	if (pos:Distance(player:EyePos()) >= 100) then
		return false;
	end;

	return true;
end;

function PLUGIN:StartCommand(client, command)
	if (!client:GetNetVar("sitHelperPos")) then
		return
	end

	if command:KeyDown(IN_DUCK) then
		command:RemoveKey(IN_DUCK)
	end
end

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")