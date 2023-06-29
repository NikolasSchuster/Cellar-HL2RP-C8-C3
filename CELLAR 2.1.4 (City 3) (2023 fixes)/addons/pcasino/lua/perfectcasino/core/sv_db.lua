function PerfectCasino.Database.Startup()
	if not sql.TableExists("pcasino_ents") then
		sql.Query("CREATE TABLE pcasino_ents(id INTEGER PRIMARY KEY AUTOINCREMENT, class VARCHAR(32) NOT NULL, settings TEXT, pos VARCHAR(128), ang VARCHAR(128), map VARCHAR(128));")
	end
end

function PerfectCasino.Database.CreateEntity(class, settings, pos, ang)
	if not pos then return end
	if not ang then return end
	sql.Query(string.format("INSERT INTO pcasino_ents(class, settings, pos, ang, map) VALUES('%s', '%s', '%s', '%s', '%s');",
		sql.SQLStr(class, true),
		sql.SQLStr(util.TableToJSON(settings), true),
		sql.SQLStr(util.TableToJSON({x = pos.x, y = pos.y, z = pos.z}), true),
		sql.SQLStr(util.TableToJSON({x = ang.x, y = ang.y, z = ang.z}), true),
		sql.SQLStr(game.GetMap(), true)
	))

	return sql.QueryRow("SELECT id FROM pcasino_ents ORDER BY id DESC;")['id']
end

function PerfectCasino.Database.GetEntites()
	return sql.Query(string.format("SELECT * FROM pcasino_ents WHERE map = '%s';", sql.SQLStr(game.GetMap(), true)))
end

function PerfectCasino.Database.DeleteEntityByID(id)
	return sql.Query(string.format("DELETE FROM pcasino_ents WHERE id = %i;", id))
end

function PerfectCasino.Database.UpdatePositions(id, pos)
	sql.Query(string.format("UPDATE pcasino_ents SET pos = '%s' WHERE id = %i;", util.TableToJSON({x = pos.x, y = pos.y, z = pos.z}), id))
end

function PerfectCasino.Database.UpdateAllPositions()
	for k, v in ipairs(ents.FindByClass("pcasino_*")) do
		if not v.DatabaseID then continue end

		local pos = v:GetPos()
		PerfectCasino.Database.UpdatePositions(v.DatabaseID, pos)
	end
end