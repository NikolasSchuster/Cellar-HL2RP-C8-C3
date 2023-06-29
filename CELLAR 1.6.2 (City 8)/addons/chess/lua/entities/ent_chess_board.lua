
if SERVER then
   AddCSLuaFile()
   
   --From client
   util.AddNetworkString( "Chess ClientRequestMove" )
   util.AddNetworkString( "Chess ClientResign" ) --Why not just have a client-side exit func? :/
   util.AddNetworkString( "Chess ClientCallDraw" )
   --2-way
   util.AddNetworkString( "Chess DrawOffer" )
   util.AddNetworkString( "Chess PromotionSelection" )
   util.AddNetworkString( "Chess Update" )
   --From server
   util.AddNetworkString( "Chess GameOver" )
   
   CreateConVar( "chess_debug", 0, FCVAR_ARCHIVE, "Debug mode." )
end

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_slam.mdl")
local UseHL2Model = false
ENT.Models = {
	["board"] = Model("models/props_phx/games/chess/board.mdl"),
	["table"] = (UseHL2Model and Model( "models/props_c17/furnituretable001a.mdl" ) or Model("models/props/de_tides/restaurant_table.mdl")),
	["hl2table"] = Model( "models/props_c17/furnituretable001a.mdl" ),
	
	["BlackPawn"] = Model("models/props_phx/games/chess/black_pawn.mdl"),		["WhitePawn"] = Model("models/props_phx/games/chess/white_pawn.mdl"),
	["BlackRook"] = Model("models/props_phx/games/chess/black_rook.mdl"),		["WhiteRook"] = Model("models/props_phx/games/chess/white_rook.mdl"),
	["BlackKnight"] = Model("models/props_phx/games/chess/black_knight.mdl"),	["WhiteKnight"] = Model("models/props_phx/games/chess/white_knight.mdl"),
	["BlackBishop"] = Model("models/props_phx/games/chess/black_bishop.mdl"),	["WhiteBishop"] = Model("models/props_phx/games/chess/white_bishop.mdl"),
	["BlackQueen"] = Model("models/props_phx/games/chess/black_queen.mdl"),		["WhiteQueen"] = Model("models/props_phx/games/chess/white_queen.mdl"),
	["BlackKing"] = Model("models/props_phx/games/chess/black_king.mdl"),		["WhiteKing"] = Model("models/props_phx/games/chess/white_king.mdl"),
	
	["dama"] = Model("models/props_phx/games/chess/white_dama.mdl"),
}

ENT.PrintName		= "Chess"
ENT.Author			= "my_hat_stinks"
ENT.Information		= "A chess board"
ENT.Category		= "Game boards"

ENT.Game = "Chess"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AdminSpawnable = true


ENT.TopLeft = Vector(2.5,-15.5,-16) --Local pos of the board's corner (Used for alignment)
ENT.SquareH = 19.5 ENT.SquareW = 20 --For drawing square highlights
ENT.RealH = 4 ENT.RealW = 3.9 --For vector positions

ENT.MoveTime = 0.3 --Time it takes to complete a move
ENT.MoveSound = Sound( "physics/wood/wood_solid_impact_soft1.wav" )

local NumToLetter = {"a", "b", "c", "d", "e", "f", "g", "h", ["a"]=1, ["b"]=2, ["c"]=3, ["d"]=4, ["e"]=5, ["f"]=6, ["g"]=7, ["h"]=8} --Used extensively for conversions
local PassantFlags = {1,2,4,8,16,32,64,128} --Bitflags, translate to board positions 1-8. For En Passant rule

--Status
local CHESS_INACTIVE = 0
local CHESS_WHITEMOVE = 1
local CHESS_BLACKMOVE = 2
local CHESS_WHITEPROMO = 3
local CHESS_BLACKPROMO = 4
local CHESS_WAGER = 5

--Captured piece squares
local CHESS_WCAP1 = 10
local CHESS_WCAP2 = 11
local CHESS_BCAP1 = 12
local CHESS_BCAP2 = 13

--Draws
local CHESS_DRAW_50 = 0
local CHESS_DRAW_3 = 1

ENT.StartState = CHESS_WHITEMOVE

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "BlackPassant" )
	self:NetworkVar( "Int", 1, "WhitePassant" )
	
	self:NetworkVar( "Int", 2, "ChessState" )
	self:NetworkVar( "Bool", 0, "Playing" )
	
	self:NetworkVar( "Float", 0, "WhiteWager" )
	self:NetworkVar( "Float", 1, "BlackWager" )
	
	self:NetworkVar( "Entity", 0, "WhitePlayer" )
	self:NetworkVar( "Entity", 1, "BlackPlayer" )
	self:NetworkVar( "Entity", 2, "TableEnt" )
	
	self:NetworkVar( "Int", 3, "MoveCount" )
	self:NetworkVar( "Bool", 1, "Repetition" )
	
	self:NetworkVar( "Bool", 2, "PSWager" )
	
	self:NetworkVar( "Float", 2, "WhiteTime" )
	self:NetworkVar( "Float", 3, "BlackTime" )
end
local ChessScale = Matrix({
	{0.1225,0,0,0},
	{0,0.1225,0,0},
	{0,0,0.1225,0},
	{0,0,0,0},
})

local SpawnedEnts = {}
function ENT:SpawnFunction( ply, tr, ClassName )
	if (not tr.Hit) then return end
	
	local SpawnPos = tr.HitPos --+ (tr.HitNormal*16)
	
	local board = (IsValid(self) and self) or ents.Create( ClassName )
	board.SavePos = SpawnPos
	board:SetPos( SpawnPos )
	board:Spawn()
	
	SpawnedEnts[board]=true
	
	return board
end
function ENT:Initialize()
	if SERVER then
		local pos,ang = self:GetPos(),self:GetAngles()
		
		local tbl = ents.Create( "prop_physics" )
		tbl:SetModel( self.Models["table"] )
		tbl:SetPos( pos+ Vector(0,0,UseHL2Model and 15 or 0) )
		tbl:Spawn()
		tbl:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		tbl:PhysicsInit( SOLID_BBOX )
		tbl:SetMoveType( MOVETYPE_NONE )
		tbl:SetMaxHealth( 1000000 )
		tbl.IsChessEntity = true
		local height = (tbl:OBBMaxs()[3] - tbl:OBBMins()[3])
		
		local BlackSeat = ents.Create( "prop_vehicle_prisoner_pod" )
		BlackSeat:SetModel( "models/nova/chair_plastic01.mdl" )
		BlackSeat:SetPos( pos+ (self:GetRight()*40) )
		BlackSeat:SetAngles( ang )
		BlackSeat:Spawn()
		BlackSeat:SetMoveType( MOVETYPE_NONE )
		BlackSeat:SetCollisionGroup( COLLISION_GROUP_WORLD )
		BlackSeat.IsChessEntity = true
		
		local WhiteSeat = ents.Create( "prop_vehicle_prisoner_pod" )
		WhiteSeat:SetModel( "models/nova/chair_plastic01.mdl" )
		WhiteSeat:SetPos( pos+ (self:GetRight()*-40) )
		ang:RotateAroundAxis( self:GetUp(),180 ) WhiteSeat:SetAngles( ang ) ang:RotateAroundAxis( self:GetUp(),180 )
		WhiteSeat:Spawn()
		WhiteSeat:SetMoveType( MOVETYPE_NONE )
		WhiteSeat:SetCollisionGroup( COLLISION_GROUP_WORLD )
		WhiteSeat.IsChessEntity = true
		
		self.IsChessEntity = true
		
		ang:RotateAroundAxis( self:GetRight(),90 )
		self.BoardHeight = Vector(0,0,height-(UseHL2Model and 6 or 3))
		self:SetPos( pos+Vector(0,0,height-(UseHL2Model and 6 or 3)) )
		self:SetAngles( ang )
		
		self.TableEnt = tbl self:SetTableEnt( tbl )
		self:SetParent( tbl )
		
		--Set some stuff up so we can see it's for chess
		self.BlackSeat = BlackSeat BlackSeat:SetNWBool("IsChessSeat", true) BlackSeat:SetNWEntity( "ChessBoard", self )
		self.WhiteSeat = WhiteSeat WhiteSeat:SetNWBool("IsChessSeat", true) WhiteSeat:SetNWEntity( "ChessBoard", self )
		
		--Darkrp lets people steal seats...
		self.WhiteSeat.DoorData = {NonOwnable = true}
		self.BlackSeat.DoorData = {NonOwnable = true}
		if self.WhiteSeat.setKeysNonOwnable then self.WhiteSeat:setKeysNonOwnable( true ) end
		if self.BlackSeat.setKeysNonOwnable then self.BlackSeat:setKeysNonOwnable( true ) end
		
		self:SetChessState( CHESS_INACTIVE )
		self:SetPlaying( false )
	end
	
	self.Pieces = { ["a"] = {}, ["b"] = {}, ["c"] = {}, ["d"] = {}, ["e"] = {}, ["f"] = {}, ["g"] = {}, ["h"] = {} }
	
	self:SetModel(self.Models["board"])
	self:DrawShadow(false)
	self:PhysicsInitShadow(false, false)
	self:SetMoveType(MOVETYPE_NONE)

	if CLIENT then
		self:EnableMatrix("RenderMultiply", ChessScale)
		hook.Add("KeyPress", self, self.GetSpectateUse)
	end
	
	self:ResetBoard()
end
function ENT:OnRemove()
	if SERVER then
		if self:GetPlaying() then
			self:EndGame( "Error" )
		end
		
		if IsValid( self.WhiteSeat ) then self.WhiteSeat:Remove() end
		if IsValid( self.BlackSeat ) then self.BlackSeat:Remove() end
		if IsValid( self.TableEnt ) then self.TableEnt:Remove() end
		
		for GridLet,column in pairs( self.Pieces ) do
			for GridNum,square in pairs( column ) do
				if IsValid( square.Ent ) then
					square.Ent:Remove()
				end
			end
		end
	end
	if CLIENT then
		if IsValid( self.PiecesEnt ) then self.PiecesEnt:Remove() end
		if IsValid( self:GetTableEnt() ) and IsValid( self:GetTableEnt().ClientChessTable ) then
			self:GetTableEnt().ClientChessTable:Remove()
		end
	end
end

function ENT:GetTableGrid( tbl, key1, key2 )
	if isnumber(key1) then key1=NumToLetter[key1+1] end
	return tbl and tbl[key1] and tbl[key1][8-key2]
end
function ENT:GetTableKey( tbl, key1, key2 )
	if isstring(key1) then key1=NumToLetter[key1]-1 end
	return tbl and tbl[key1] and tbl[key1][8-key2]
end

function ENT:GetSquare( GridLet, GridNum, tbl )
	tbl = tbl or self.Pieces
	return tbl[GridLet] and tbl[GridLet][GridNum]
end
function ENT:SquareTeam( square )
	if square.Team then return square.Team end
	
	return (IsValid(square.Ent) and (square.Ent:GetWhite() and "White" or "Black"))
end
function ENT:SquareMoved( square )
	if square.Moved~=nil then return square.Moved end
	
	return (IsValid(square.Ent) and square.Ent:GetMoved())
end
function ENT:SquareClass( square )
	if square.Class~=nil then return square.Class end
	
	return (IsValid(square.Ent) and square.Ent:GetRole())
end
function ENT:SquareColor( GridLet, GridNum )
	local NumEven = ((GridNum/2) == math.floor(GridNum/2))
	local LetEven = ((NumToLetter[GridLet]/2) == math.floor(NumToLetter[GridLet]/2))
	
	return (NumEven==LetEven) and "Black" or "White"
end

function ENT:GetRookMoves( tbl, GridLet, GridNum, IsWhite, limit, CheckTable )
	limit = limit or 8
	local count = 0
	for TargetRow = GridNum+1,8 do
		local target = self:GetSquare( GridLet, TargetRow, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then
				tbl[GridLet][TargetRow] = true
			end
			break
		end
		tbl[GridLet][TargetRow] = true
		count = count+1 if count>=limit then break end
	end
	count = 0
	for TargetRow = GridNum-1,1,-1 do
		local target = self:GetSquare( GridLet, TargetRow, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then
				tbl[GridLet][TargetRow] = true
			end
			break
		end
		tbl[GridLet][TargetRow] = true
		count = count+1 if count>=limit then break end
	end
	count = 0
	for TargetColumn = NumToLetter[GridLet]+1,8 do
		local target = self:GetSquare( NumToLetter[TargetColumn], GridNum, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then
				tbl[NumToLetter[TargetColumn]][GridNum] = true
			end
			break
		end
		tbl[NumToLetter[TargetColumn]][GridNum] = true
		count = count+1 if count>=limit then break end
	end
	count = 0
	for TargetColumn = NumToLetter[GridLet]-1,1,-1 do
		local target = self:GetSquare( NumToLetter[TargetColumn], GridNum, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then
				tbl[NumToLetter[TargetColumn]][GridNum] = true
			end
			break
		end
		tbl[NumToLetter[TargetColumn]][GridNum] = true
		count = count+1 if count>=limit then break end
	end
end
function ENT:GetBishopMoves( tbl, GridLet, GridNum, IsWhite, limit, CheckTable )
	limit = limit or 8
	local TargetColumn, count = NumToLetter[GridLet], 0
	for TargetRow = GridNum+1,8 do
		TargetColumn = TargetColumn+1 if TargetColumn>8 then break end
		local target = self:GetSquare( NumToLetter[TargetColumn], TargetRow, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then tbl[NumToLetter[TargetColumn]][TargetRow] = true end
			break
		end
		tbl[NumToLetter[TargetColumn]][TargetRow] = true
		count = count+1 if count>=limit then break end
	end
	local TargetColumn, count = NumToLetter[GridLet], 0
	for TargetRow = GridNum+1,8 do
		TargetColumn = TargetColumn-1 if TargetColumn<1 then break end
		local target = self:GetSquare( NumToLetter[TargetColumn], TargetRow, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then tbl[NumToLetter[TargetColumn]][TargetRow] = true end
			break
		end
		tbl[NumToLetter[TargetColumn]][TargetRow] = true
		count = count+1 if count>=limit then break end
	end
	local TargetColumn, count = NumToLetter[GridLet], 0
	for TargetRow = GridNum-1,1,-1 do
		TargetColumn = TargetColumn+1 if TargetColumn>8 then break end
		local target = self:GetSquare( NumToLetter[TargetColumn], TargetRow, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then tbl[NumToLetter[TargetColumn]][TargetRow] = true end
			break
		end
		tbl[NumToLetter[TargetColumn]][TargetRow] = true
		count = count+1 if count>=limit then break end
	end
	local TargetColumn, count = NumToLetter[GridLet], 0
	for TargetRow = GridNum-1,1,-1 do
		TargetColumn = TargetColumn-1 if TargetColumn<1 then break end
		local target = self:GetSquare( NumToLetter[TargetColumn], TargetRow, CheckTable )
		if target then
			if ((self:SquareTeam(target)=="White")~=IsWhite) then tbl[NumToLetter[TargetColumn]][TargetRow] = true end
			break
		end
		tbl[NumToLetter[TargetColumn]][TargetRow] = true
		count = count+1 if count>=limit then break end
	end
end
function ENT:GetMove( GridLet, GridNum, IgnoreCheck, CheckTable )
	if not (GridLet and GridNum) then return {} end
	if not NumToLetter[GridLet] then return {} end
	if NumToLetter[GridLet]<1 or NumToLetter[GridLet]>8 then return {} end
	if GridNum<1 or GridNum>8 then return {} end
	
	local square = self:GetSquare( GridLet, GridNum, CheckTable )
	if not square then return {} end
	
	local class = square.Class or (IsValid(square.Ent) and square.Ent:GetRole())
	if not class then return {} end
	
	local IsWhite = self:SquareTeam(square)=="White"
	local Moved = self:SquareMoved(square)
	
	local ChecksPerformed = false --Castling checks for check differently, flag it as done here
	local tbl = { ["a"] = {}, ["b"] = {}, ["c"] = {}, ["d"] = {}, ["e"] = {}, ["f"] = {}, ["g"] = {}, ["h"] = {} }
	if class=="Pawn" then
		local TargetRow = IsWhite and GridNum+1 or GridNum-1
		
		local CapOne = self:GetSquare( NumToLetter[NumToLetter[GridLet]-1], TargetRow, CheckTable )
		if CapOne then --There's a unit here
			local TargetWhite = self:SquareTeam(CapOne)=="White"
			if TargetWhite~=IsWhite then
				tbl[NumToLetter[NumToLetter[GridLet]-1]][TargetRow] = true
			end
		elseif (IsWhite and TargetRow==6) or ((not IsWhite) and TargetRow==3) then --Clear, EnPasse check
			local PassantCheck = IsWhite and self:GetBlackPassant() or self:GetWhitePassant()
			if (NumToLetter[GridLet]>1) and bit.band(PassantCheck, PassantFlags[ NumToLetter[GridLet]-1 ])==PassantFlags[NumToLetter[GridLet]-1]  then
				tbl[NumToLetter[NumToLetter[GridLet]-1]][TargetRow] = "ENPASSANT"
			end
		end
		
		local CapTwo = self:GetSquare( NumToLetter[NumToLetter[GridLet]+1], TargetRow, CheckTable )
		if CapTwo then
			local TargetWhite = self:SquareTeam(CapTwo)=="White"
			if TargetWhite~=IsWhite then
				tbl[NumToLetter[NumToLetter[GridLet]+1]][TargetRow] = true
			end
		elseif (IsWhite and TargetRow==6) or ((not IsWhite) and TargetRow==3) then --Clear, EnPasse check
			local PassantCheck = IsWhite and self:GetBlackPassant() or self:GetWhitePassant()
			if (NumToLetter[GridLet]<8) and bit.band(PassantCheck, PassantFlags[ NumToLetter[GridLet]+1 ])==PassantFlags[NumToLetter[GridLet]+1] then
				tbl[NumToLetter[NumToLetter[GridLet]+1]][TargetRow] = "ENPASSANT"
			end
		end
		
		local FrontOne = self:GetSquare( GridLet, TargetRow, CheckTable )
		if (not FrontOne) then --It's clear, we can move
			tbl[GridLet][TargetRow] = true
			if not Moved then
				TargetRow = IsWhite and TargetRow+1 or TargetRow-1
				if (TargetRow>0 and TargetRow<9) and (not self:GetSquare( GridLet, TargetRow, CheckTable )) then tbl[GridLet][TargetRow] = "PAWNDOUBLE" end
			end
		end
	elseif class=="Rook" then
		self:GetRookMoves( tbl, GridLet, GridNum, IsWhite, 8, CheckTable )
	elseif class=="Bishop" then
		self:GetBishopMoves( tbl, GridLet, GridNum, IsWhite, 8, CheckTable )
	elseif class=="Queen" then
		self:GetRookMoves( tbl, GridLet, GridNum, IsWhite, 8, CheckTable )
		self:GetBishopMoves( tbl, GridLet, GridNum, IsWhite, 8, CheckTable )
	elseif class=="King" then
		self:GetRookMoves( tbl, GridLet, GridNum, IsWhite, 1, CheckTable )
		self:GetBishopMoves( tbl, GridLet, GridNum, IsWhite, 1, CheckTable )
		
		ChecksPerformed = true --King performs it's own checks for Check
		
		local InCheck = true
		if not IgnoreCheck then
			for CheckLet,File in pairs(tbl) do
				for CheckNum,v in pairs(File) do
					local Positions = table.Copy( self.Pieces )
					Positions[GridLet][GridNum] = nil
					Positions[CheckLet][CheckNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
					if self:CheckForCheck( Positions, IsWhite ) then
						tbl[CheckLet][CheckNum] = nil --Puts us in check, remove it
					end
				end
			end
			
			InCheck = self:CheckForCheck( self.Pieces, IsWhite )
		end
		
		if (not Moved) and (not InCheck) then --Castling
			local Kingside = self:GetSquare( "h", GridNum, CheckTable )
			local Queenside = self:GetSquare( "a", GridNum, CheckTable )
			if Kingside and not self:SquareMoved(Kingside) then
				if not (self:GetSquare( "f", GridNum, CheckTable ) or self:GetSquare( "g", GridNum, CheckTable )) then
					local Positions = table.Copy( self.Pieces ) Positions[GridLet][GridNum] = nil Positions["f"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
					local FSafe = not self:CheckForCheck( Positions, IsWhite )
					local Positions = table.Copy( self.Pieces ) Positions[GridLet][GridNum] = nil Positions["g"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
					local GSafe = not self:CheckForCheck( Positions, IsWhite )
					if FSafe and GSafe then
						tbl["g"][GridNum] = "CASTLEKINGSIDE"
					end
				end
			end
			if Queenside and not self:SquareMoved(Queenside) then
				if not (self:GetSquare( "b", GridNum, CheckTable ) or self:GetSquare( "c", GridNum, CheckTable ) or self:GetSquare( "d", GridNum, CheckTable )) then
					local Positions = table.Copy( self.Pieces ) Positions[GridLet][GridNum] = nil Positions["c"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
					local CSafe = not self:CheckForCheck( Positions, IsWhite )
					local Positions = table.Copy( self.Pieces ) Positions[GridLet][GridNum] = nil Positions["d"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
					local DSafe = not self:CheckForCheck( Positions, IsWhite )
					if CSafe and DSafe then
						tbl["c"][GridNum] = "CASTLEQUEENSIDE"
					end
				end
			end
		end
	elseif class=="Knight" then
		local Up = NumToLetter[GridLet] + 2
		if Up and Up >=1 and Up<=8 then
			local Pos1 = self:GetSquare( NumToLetter[Up], GridNum-1, CheckTable )
			local Pos2 = self:GetSquare( NumToLetter[Up], GridNum+1, CheckTable )
			if (GridNum-1>=1) and ((not Pos1) or (self:SquareTeam(Pos1)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Up]][GridNum-1] = true
			end
			if (GridNum+1<=8) and ((not Pos2) or (self:SquareTeam(Pos2)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Up]][GridNum+1] = true
			end
		end
		
		local Down = NumToLetter[GridLet] - 2
		if Down and Down>=1 and Down<=8 then
			local Pos1 = self:GetSquare( NumToLetter[Down], GridNum-1, CheckTable )
			local Pos2 = self:GetSquare( NumToLetter[Down], GridNum+1, CheckTable )
			if (GridNum-1>=1) and ((not Pos1) or (self:SquareTeam(Pos1)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Down]][GridNum-1] = true
			end
			if (GridNum+1<=8) and ((not Pos2) or (self:SquareTeam(Pos2)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Down]][GridNum+1] = true
			end
		end
		
		local Let = NumToLetter[GridLet]
		
		local Left = GridNum - 2
		if Left and Left>=1 and Left<=8 then
			local Pos1 = self:GetSquare( NumToLetter[Let-1], Left, CheckTable )
			local Pos2 = self:GetSquare( NumToLetter[Let+1], Left, CheckTable )
			if Let>1 and ((not Pos1) or (self:SquareTeam(Pos1)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Let-1]][Left] = true
			end
			if Let<8 and ((not Pos2) or (self:SquareTeam(Pos2)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Let+1]][Left] = true
			end
		end
		
		local Right = GridNum + 2
		if Right and Right>=1 and Right<=8 then
			local Pos1 = self:GetSquare( NumToLetter[Let-1], Right, CheckTable )
			local Pos2 = self:GetSquare( NumToLetter[Let+1], Right, CheckTable )
			if Let>1 and ((not Pos1) or (self:SquareTeam(Pos1)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Let-1]][Right] = true
			end
			if Let<8 and ((not Pos2) or (self:SquareTeam(Pos2)==(IsWhite and "Black" or "White"))) then
				tbl[NumToLetter[Let+1]][Right] = true
			end
		end
	end
	
	if not IgnoreCheck then
		for CheckLet,File in pairs(tbl) do
			for CheckNum,v in pairs(File) do
				local Positions = table.Copy( self.Pieces )
				Positions[GridLet][GridNum] = nil
				Positions[CheckLet][CheckNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
				if self:CheckForCheck( Positions, IsWhite ) then
					tbl[CheckLet][CheckNum] = nil --Puts us in check, remove it
				end
			end
		end
	end
	
	return tbl
end

function ENT:CastlingCheck( square, IsWhite )
	if not square then return false,false end
	
	local GridNum = IsWhite and 1 or 8
	local moved = self:SquareMoved( square )
	local InCheck = self:CheckForCheck( self.Pieces, IsWhite )
	local Queenside, Kingside = false, false
	if (not Moved) and (not InCheck) then --Castling
		local Kingside = self:GetSquare( "h", GridNum, CheckTable )
		local Queenside = self:GetSquare( "a", GridNum, CheckTable )
		if Kingside and not self:SquareMoved(Kingside) then
			if not (self:GetSquare( "f", GridNum, CheckTable ) or self:GetSquare( "g", GridNum, CheckTable )) then
				local Positions = table.Copy( self.Pieces ) Positions["d"][GridNum] = nil Positions["f"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
				local FSafe = not self:CheckForCheck( Positions, IsWhite )
				local Positions = table.Copy( self.Pieces ) Positions["d"][GridNum] = nil Positions["g"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
				local GSafe = not self:CheckForCheck( Positions, IsWhite )
				if FSafe and GSafe then
					Kingside = true
				end
			end
		end
		if Queenside and not self:SquareMoved(Queenside) then
			if not (self:GetSquare( "b", GridNum, CheckTable ) or self:GetSquare( "c", GridNum, CheckTable ) or self:GetSquare( "d", GridNum, CheckTable )) then
				local Positions = table.Copy( self.Pieces ) Positions["d"][GridNum] = nil Positions["c"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
				local CSafe = not self:CheckForCheck( Positions, IsWhite )
				local Positions = table.Copy( self.Pieces ) Positions["d"][GridNum] = nil Positions["d"][GridNum] = {Team = IsWhite and "White" or "Black", Class = class, Moved = true}
				local DSafe = not self:CheckForCheck( Positions, IsWhite )
				if CSafe and DSafe then
					Queenside = true
				end
			end
		end
	end
	return Queenside, Kingside
end

function ENT:RefreshSquares()
	self.Squares = {}
	
	local pos = self:LocalToWorld( self.TopLeft )
	local ang = self:GetUp():Angle()
	
	for i=0,7 do
		self.Squares[i] = {}
		for n=0,7 do
			self.Squares[i][n] = Vector( pos[1]- ((self.RealH*(i))+(self.RealH/2)), pos[2]+ ((self.RealW*(n))+(self.RealW/2)), pos[3] )
		end
	end
	local HalfW, HalfH = (self.RealW/2), (self.RealH/2)
	self.Squares[CHESS_WCAP1] = {}
	self.Squares[CHESS_WCAP2] = {}
	self.Squares[CHESS_BCAP1] = {}
	self.Squares[CHESS_BCAP2] = {}
	for n=0,7 do
		self.Squares[CHESS_WCAP1][n] = Vector( pos[1]- ((self.RealH*(8.2))+(self.RealH/2)), pos[2]+ (self.RealW*(4))+ (HalfW*(n+1)), pos[3] )
		self.Squares[CHESS_WCAP2][n] = Vector( pos[1]- ((self.RealH*(9.2))+(self.RealH/2)), pos[2]+ (self.RealW*(4))+ (HalfW*(n+1)), pos[3] )
	end
	for n=0,7 do
		self.Squares[CHESS_BCAP1][n] = Vector( pos[1]- ((self.RealH*(-1.2))+(self.RealH/2)), pos[2]+ (self.RealW*(4))- (HalfW*(n+1)), pos[3] )
		self.Squares[CHESS_BCAP2][n] = Vector( pos[1]- ((self.RealH*(-2.2))+(self.RealH/2)), pos[2]+ (self.RealW*(4))- (HalfW*(n+1)), pos[3] )
	end
end
function ENT:GetSquarePos( GridLetter, GridNumber)
	return self:GetTableKey( self.Squares, GridLetter, GridNumber )
end
function ENT:ResetBoard()
	if SERVER then
		self.SurrenderOffer = nil
		
		self:SetWhiteWager( -1 )
		self:SetBlackWager( -1 )
		
		self:SetWhitePassant( 0 )
		self:SetBlackPassant( 0 )
		
		self:SetWhiteTime( 600 )
		self:SetBlackTime( 600 )
		
		self:SetMoveCount( 0 )
		self:SetRepetition( false )
		self.RepetitionTable = {}
	end
	self:RefreshSquares()
	
	if self.Pieces then
		for _,File in pairs( self.Pieces ) do
			for _,Square in pairs(File) do
				if IsValid(Square.Ent) then Square.Ent:SetGridNum(-1) Square.Ent:Remove() end
			end
		end
	end
	self.Pieces = {
		["a"] = {
			[1] = {Team="White",Class="Rook",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Rook",Moved=false},
		},
		["b"] = {
			[1] = {Team="White",Class="Knight",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Knight",Moved=false},
		},
		["c"] = {
			[1] = {Team="White",Class="Bishop",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Bishop",Moved=false},
		},
		["d"] = {
			[1] = {Team="White",Class="Queen",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Queen",Moved=false},
		},
		["e"] = {
			[1] = {Team="White",Class="King",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="King",Moved=false},
		},
		["f"] = {
			[1] = {Team="White",Class="Bishop",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Bishop",Moved=false},
		},
		["g"] = {
			[1] = {Team="White",Class="Knight",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Knight",Moved=false},
		},
		["h"] = {
			[1] = {Team="White",Class="Rook",Moved=false}, [2] = {Team="White",Class="Pawn",Moved=false}, [7] = {Team="Black",Class="Pawn",Moved=false}, [8] = {Team="Black",Class="Rook",Moved=false},
		},
		[CHESS_WCAP1] = {}, [CHESS_WCAP2] = {}, [CHESS_BCAP1] = {}, [CHESS_BCAP2] = {},
	}
	self:Update()
end

function ENT:Update( Move1, Move2 )
	if CLIENT then return end
	Move1,Move2 = Move1 or {},Move2 or {}
	net.Start( "Chess Update" )
		net.WriteEntity( self )
		net.WriteTable( self.Pieces )
		if Move1 then
			net.WriteTable( Move1 )
			if Move2 then net.WriteTable( Move2 ) end
		end
	net.Broadcast()
end

ENT.LastTick = 0
ENT.LastTickTeam = ""
function ENT:Think()
	if SERVER then
		if self.Removing then return end

		if !IsValid(self.TableEnt) or !(IsValid(self.WhiteSeat) and IsValid(self.BlackSeat)) then
			self.Removing = true 
			self:Remove()
			return
		end

		if self:GetChessState() != CHESS_WAGER then
			self:SetWhiteWager( -1 )
			self:SetBlackWager( -1 )
		end

		if self:GetChessState()==CHESS_WHITEMOVE or self:GetChessState()==CHESS_WHITEPROMO then
			if self.LastTickTeam=="White" then self:SetWhiteTime( math.max(0,self:GetWhiteTime()-(CurTime()-self.LastTick)) ) end
			self.LastTickTeam = "White"
			
			if self:GetWhiteTime()<=0 then
				local WhitePly = self:GetPlayer( "White" )
				local BlackPly = self:GetPlayer( "Black" )
				
				local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
				local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
				
				self:EndGame( "Black" )
				ix.chat.Send(BlackPly, "chess", "Время вышло! "..BlackName.." побеждает "..WhiteName.."!")
			end
		elseif self:GetChessState()==CHESS_BLACKMOVE or self:GetChessState()==CHESS_BLACKPROMO then
			if self.LastTickTeam=="Black" then self:SetBlackTime( math.max(0,self:GetBlackTime()-(CurTime()-self.LastTick)) ) end
			self.LastTickTeam = "Black"
			
			if self:GetBlackTime()<=0 then
				local WhitePly = self:GetPlayer( "White" )
				local BlackPly = self:GetPlayer( "Black" )
				
				local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
				local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
				
				self:EndGame( "White" )
				ix.chat.Send(WhitePly, "chess", "Время вышло! "..WhiteName.." побеждает "..BlackName.."!")
			end
		else
			self.LastTickTeam = ""
		end
		self.LastTick = CurTime()
	end
	if CLIENT then
		local tbl = self:GetTableEnt()
		if tbl.ChessIsErrorModel or tbl:GetModel()=="models/error.mdl" then --Much cheaper than a file.Find
			tbl.ChessIsErrorModel = true
			self:SetParent( nil )
			tbl:SetNoDraw( true )
			
			tbl.ClientChessTable = IsValid(tbl.ClientChessTable) and tbl.ClientChessTable or ClientsideModel( self.Models["hl2table"] )
			local ent = tbl.ClientChessTable
			
			if not tbl.PerformedChessTableSetup then
				
				ent:SetPos( tbl:GetPos()+Vector(0,0,13) )
				
				tbl:SetMoveType( MOVETYPE_NONE )
				tbl:PhysicsInit( SOLID_NONE )
				tbl:SetCollisionGroup( COLLISION_GROUP_WORLD )
				
				ent:SetMoveType( MOVETYPE_NONE )
				ent:PhysicsInit( SOLID_VPHYSICS )
				ent:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				
				tbl.PerformedChessTableSetup = true
			end
			
			tbl:SetModel( self.Models["hl2table"] )
			tbl:SetPos( ent:GetPos() )
			tbl:SetNoDraw( true )
			self:SetPos( ent:GetPos()+Vector(0,0,17) )
		elseif IsValid( tbl) and IsValid( tbl.ClientChessTable ) then
			tbl.ClientChessTable:Remove()
			tbl.PerformedChessTableSetup = nil
		end
	end
end

function ENT:GetPlayer( team )
	if (team=="White" or team==true) then
		return (IsValid(self.WhiteSeat) and self.WhiteSeat:GetDriver())
	else
		return (IsValid(self.BlackSeat) and self.BlackSeat:GetDriver())
	end
end
function ENT:EndGame( winner, HideMsg )
	self:SetChessState( CHESS_INACTIVE )
	self:SetPlaying( false )
	
	local White = self:GetPlayer( "White" )
	local Black = self:GetPlayer( "Black" )
	timer.Simple( 0.5, function()
		if not IsValid(self) then return end
		if IsValid(Black) and Black:GetVehicle()==self.BlackSeat then Black:ExitVehicle() end
		if IsValid(White) and White:GetVehicle()==self.WhiteSeat then White:ExitVehicle() end
	end)
end
function ENT:DoCapture( square, EndLet, EndNum )
	if not square then return end
	
	table.Empty( self.RepetitionTable ) --When it's gone, it's gone for good
	self:SetRepetition( false )
	
	self:SetMoveCount( 0 )
	
	local class = square.Class
	
	local made = false
	local CapLet,CapNum
	if square.Team=="White" then --Black captured
		for i=CHESS_BCAP1,CHESS_BCAP2 do
			for n=1,8 do
				local CapSq = self:GetSquare( i, n )
				if not CapSq then
					self.Pieces[i][n] = {Team="White", Class=class, Moved=false}
					CapSq = self.Pieces[i][n]
					
					made = true
					CapLet,CapNum = i,n
					break
				end
			end
			if made then break end
		end
	else
		for i=CHESS_WCAP1,CHESS_WCAP2 do
			for n=1,8 do
				local CapSq = self:GetSquare( i, n )
				if not CapSq then
					self.Pieces[i][n] = {Team="Black", Class=class, Moved=false}
					CapSq = self.Pieces[i][n]
					
					made = true
					CapLet,CapNum = i,n
					break
				end
			end
			if made then break end
		end
	end
	
	return {From={EndLet,EndNum}, To={CapLet,CapNum}}
end

function ENT:CheckForCheck( tbl, CheckWhite )
	if not tbl then return true end --Assume invalid move
	
	local king, KingLet, KingNum
	for GridLet,File in pairs(tbl) do
		for GridNum,square in pairs(File) do
			if square and self:SquareClass(square)=="King" and ((CheckWhite and self:SquareTeam(square)=="White") or ((not CheckWhite) and self:SquareTeam(square)=="Black")) then
				king = square
				KingLet = GridLet
				KingNum = GridNum
				break
			end
		end
		if king then break end
	end
	if not king then return true end --Assume invalid
	
	for GridLet,File in pairs(tbl) do
		for GridNum,square in pairs(File) do
			if square and ((CheckWhite and self:SquareTeam(square)=="Black") or ((not CheckWhite) and self:SquareTeam(square)=="White")) then
				local Moves = self:GetMove( GridLet, GridNum, true, tbl )
				if Moves[KingLet] and Moves[KingLet][KingNum] then return true end --Something can take the king
			end
		end
	end
	
	return false --King is safe
end
function ENT:IsCheckmate( CheckWhite )
--	local IsCheck = self:CheckForCheck( self.Pieces, CheckWhite ) --We no longer check for check here, this is also a stalemate check
--	if not IsCheck then return false end
	
	for GridLet,File in pairs(self.Pieces) do
		for GridNum,square in pairs(File) do
			if square and ((CheckWhite and self:SquareTeam(square)=="White") or ((not CheckWhite) and self:SquareTeam(square)=="Black")) then
				local Moves = self:GetMove( GridLet, GridNum, false, tbl )
				for MoveLet,File in pairs(Moves) do
					if table.Count(File)>0 then return false end --There's a valid move, it's fine
				end
			end
		end
	end
	
	return true
end
function ENT:NoMaterialCheck()
	local BlackMat = {}
	local WhiteMat = {}
	
	for GridLet,File in pairs(self.Pieces) do
		if GridLet==CHESS_WCAP1 or GridLet==CHESS_WCAP2 or GridLet==CHESS_BCAP1 or GridLet==CHESS_BCAP2 then continue end
		for GridNum,square in pairs(File) do
			if square then
				local IsWhite = self:SquareTeam(square)=="White"
				local Class = self:SquareClass(square)
				if Class=="Queen" or Class=="Rook" or Class=="Pawn" then return false end --Always sufficient material
				if Class=="King" then continue end --Don't count king
				
				if IsWhite then
					table.insert( WhiteMat, {Square=square, Class=Class, GridLet=GridLet, GridNum=GridNum} )
				else
					table.insert( BlackMat, {square=square, Class=Class, GridLet=GridLet, GridNum=GridNum} )
				end
			end
		end
	end
	
	if #BlackMat==0 and #WhiteMat==0 then return true end --Kings only, draw
	if #BlackMat==1 and #WhiteMat==0 and (BlackMat[1].Class=="Bishop" or BlackMat[1].Class=="Knight") then return true end --King versus King+Bishop/Knight
	if #BlackMat==0 and #WhiteMat==1 and (WhiteMat[1].Class=="Bishop" or WhiteMat[1].Class=="Knight") then return true end --King versus King+Bishop/Knight
	
	local BishopCol
	for i=1,#BlackMat do
		if BlackMat[i].Class~="Bishop" then return false end --Has non-bishops, it's fine
		if not BishopCol then BishopCol = self:SquareColor(BlackMat[i].GridLet,BlackMat[i].GridNum) end
		if BishopCol~=self:SquareColor(BlackMat[i].GridLet,BlackMat[i].GridNum) then return false end --Bishops are on different colours, it's fine
	end
	for i=1,#WhiteMat do
		if WhiteMat[i].Class~="Bishop" then return false end
		if not BishopCol then BishopCol = self:SquareColor(WhiteMat[i].GridLet,WhiteMat[i].GridNum) end
		if BishopCol~=self:SquareColor(WhiteMat[i].GridLet,WhiteMat[i].GridNum) then return false end --Even if it's the enemy on a different colour, checkmate is possible
	end
	
	return true
end

function table.EqualsTable( CheckTable, MatchTable, depth )
	if not (CheckTable and MatchTable) then return false end
	depth = depth or 1
	if depth>=15 then error("Unable to match tables: Tables too deep!") end
	
	if table.Count( CheckTable ) ~= table.Count( MatchTable ) then return false end
	for k,v in pairs( CheckTable ) do
		if type(v)=="table" then
			if type(MatchTable[k])~="table" then return false end
			if not table.EqualsTable( v, MatchTable[k], depth+1 ) then return false end
		elseif type(v)=="Entity" then
		else
			if MatchTable[k]~=v then return false end
		end
	end
	return true
end
function ENT:DoRepetition()
	local Pieces = self.Pieces
	local WKing = self:GetSquare( "d", 1 )
	local BKing = self:GetSquare( "d", 8 )
	local WCQ, WCK = self:CastlingCheck( WKing, true ) --WhiteCastleQueenside, Kingside
	local BCQ, BCK = self:CastlingCheck( BKing, false ) --BlackCastleQueenside, Kingside
	for _,Saved in pairs( self.RepetitionTable ) do
		if table.EqualsTable( Saved.Pieces, Pieces ) and Saved.WCQ==WCQ and Saved.WCK==WCK and Saved.BCQ==BCQ and Saved.BCK==BCK then
			Saved.Count = Saved.Count+1
			if Saved.Count>=3 then self:SetRepetition( true ) end
			return
		end
	end
	self:SetRepetition( false )
	--No match
	table.insert( self.RepetitionTable, {
		WCQ = WCQ, WCK = WCK, BCQ = BCQ, BCK = BCK,
		Pieces = table.Copy( Pieces ), Count = 1
	})
end

function ENT:DoMove( StartLet, StartNum, EndLet, EndNum )
	if CLIENT then return end
	if not (StartLet and EndLet and StartNum and EndNum) then return end
	if (StartLet==EndLet) and (StartNum==EndNum) then return end
	
	local Start = self:GetSquare( StartLet, StartNum )
	if not Start then return end
	
	local Moves = self:GetMove( StartLet, StartNum )
	if not Moves[EndLet][EndNum] then return end
	local Move = Moves[EndLet][EndNum]
	
	self:SetWhitePassant( 0 ) --Reset after the move verified
	self:SetBlackPassant( 0 )
	self:SetRepetition( false )
	
	self:SetMoveCount( ((Start.Class=="Pawn") and 0) or self:GetMoveCount()+1 )
	local IgnoreRepetition
	
	local CapMove
	if Move=="PAWNDOUBLE" then
		if Start.Team=="White" then
			self:SetWhitePassant( PassantFlags[NumToLetter[StartLet]] )
		else
			self:SetBlackPassant( PassantFlags[NumToLetter[StartLet]] )
		end
	elseif Move=="ENPASSANT" then
		local Take = self:GetSquare( EndLet, StartNum )
		if Take and Take.Class then
			CapMove = self:DoCapture( Take, EndLet, StartNum )
		end
		self.Pieces[EndLet][StartNum] = nil
		IgnoreRepetition = true --Passant state is counted, and is never the same
	elseif Move=="CASTLEKINGSIDE" then
		CapMove = self:DoMove( "h", StartNum, "f", StartNum )
	elseif Move=="CASTLEQUEENSIDE" then
		CapMove = self:DoMove( "a", StartNum, "d", StartNum )
	end
	
	local End = self:GetSquare( EndLet, EndNum )
	if not End then
		self.Pieces[EndLet] = self.Pieces[EndLet] or {}
		self.Pieces[EndLet][EndNum] = self.Pieces[EndLet][EndNum] or {}
		End = self.Pieces[EndLet][EndNum]
	end
	if End.Class then
		CapMove = self:DoCapture( End, EndLet, EndNum )
	end
	
	End.Team=Start.Team
	End.Class=Start.Class
	End.Moved=true
	
	self.Pieces[StartLet][StartNum] = nil
	
	local ply = self:GetPlayer( End.Team )
	if (EndNum==1 or EndNum==8) and End.Class=="Pawn" and IsValid(ply) then --End of the board
		net.Start( "Chess PromotionSelection" )
			net.WriteInt( NumToLetter[EndLet], 5 )
		net.Send( ply )
		self:SetChessState( End.Team=="White" and CHESS_WHITEPROMO or CHESS_BLACKPROMO )
	else
		self:SetChessState( End.Team=="White" and CHESS_BLACKMOVE or CHESS_WHITEMOVE )
	end
	
	local move = {From={StartLet,StartNum},To={EndLet,EndNum}}
	self:Update( move, CapMove )
	
	local IsCheck = self:CheckForCheck( self.Pieces, End.Team~="White" )
	local Checkmate = self:IsCheckmate( End.Team~="White" )

	if IsCheck and Checkmate then
		local WhitePly = self:GetPlayer( "White" )
		local BlackPly = self:GetPlayer( "Black" )
		
		local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
		local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
		self:EndGame( End.Team )

		if End.Team=="White" then
			ix.chat.Send(WhitePly, "chess", WhiteName.." поставил мат "..BlackName.."!")
		else
			ix.chat.Send(BlackPly, "chess", BlackName.." поставил мат "..WhiteName.."!")
		end
		
		return
	elseif Checkmate then
		local WhitePly = self:GetPlayer( "White" )
		local BlackPly = self:GetPlayer( "Black" )
		
		local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
		local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
		self:EndGame()
		ix.chat.Send(BlackPly or WhitePly, "chess", "Пат! " .. WhiteName .. " и " .. BlackName .. " завершают ничьей!")

		return
	end
	
	local NoMaterial = self:NoMaterialCheck()
	if NoMaterial then
		local WhitePly = self:GetPlayer( "White" )
		local BlackPly = self:GetPlayer( "Black" )
		
		local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
		local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
		self:EndGame()
		ix.chat.Send(BlackPly or WhitePly, "chess", "Пат! " .. WhiteName .. " и " .. BlackName .. " завершают ничьей!")

		return
	end
	
	if IgnoreRepetition then
		self:SetRepetition( false )
	else
		self:DoRepetition()
	end
	return move
end
function ENT:GameName()
	return self.Game or "a board game"
end

if CLIENT then
	local ChessPanel, WagerPanel
	function ENT:Refresh()
		for GridLet,column in pairs( self.Pieces ) do
			for GridNum,square in pairs( column ) do
				if (not IsValid( square.Ent )) or (NumToLetter[square.Ent:GetGridLet()]~=GridLet) or (square.Ent:GetGridNum()~=GridNum) then
					column[GridNum] = nil
				end
			end
		end
	end
	
	function ENT:RequestMove( StartLet, StartNum, EndLet, EndNum)
		if not (StartLet and StartNum and EndLet and EndNum) then return end
		
		net.Start( "Chess ClientRequestMove" )
			net.WriteInt( StartLet+1, 5 )
			net.WriteInt( 8-StartNum, 5 )
			net.WriteInt( EndLet+1, 5 )
			net.WriteInt( 8-EndNum, 5 )
		net.SendToServer()
	end
	
	local PanelCol = {
		Main = Color(0,0,0,200), ToMove = Color(200,200,200,20), Text = Color(180,180,180),
		White = Color(255,255,255), Black = Color(20,20,20,255),
	}
	surface.CreateFont( "ChessTextSmall", { font = "Arial", size = 16, weight = 600})
	surface.CreateFont( "ChessText", { font = "Arial", size = 24, weight = 600})
	surface.CreateFont( "ChessTextLarge", { font = "Arial", size = 32, weight = 600})
	function ENT:CreateChessPanel()
		local frame = vgui.Create( "DFrame" )
		frame:SetSize(300,135)
		frame:SetPos( (ScrW()/2)-100, ScrH()-150 )
		--frame:SetDraggable( false )
		frame:SetTitle( "" )
		frame:ShowCloseButton( false )
		frame:SetDeleteOnClose( true )
		frame.Paint = function( s,w,h )
			draw.RoundedBox( 8, 0, 0, w, h, PanelCol.Main )
		end
		frame:DockMargin( 0,0,0,0 )
		frame:DockPadding( 5,6,5,5 )
		
		local TimePnl = vgui.Create( "DPanel", frame )
		TimePnl:Dock( RIGHT )
		TimePnl:SetWide( 100 )
		TimePnl:DockMargin( 2,2,2,2 )
		TimePnl.Paint = function(s,w,h)
			draw.RoundedBox( 16, 0, 0, w, (h/2)-1, PanelCol.ToMove )
			draw.RoundedBox( 16, 0, (h/2)+1, w, (h/2)-1, PanelCol.ToMove )
			
			draw.SimpleText( string.FormattedTime( math.Round(self:GetWhiteTime() or 300,1), "%02i:%02i" ), "ChessText", w/2, h/4, PanelCol.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( string.FormattedTime( math.Round(self:GetBlackTime() or 300,1), "%02i:%02i" ), "ChessText", w/2, (h/4)+(h/2), PanelCol.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		local ToMove = vgui.Create( "DPanel", frame )
		ToMove:SetSize(200,80)
		ToMove:Dock( TOP )
		ToMove.Paint = function( s,w,h )
			draw.RoundedBox( 4, 0, 0, w, h, PanelCol.ToMove )
			draw.SimpleText( "To move", "ChessTextSmall", 5, 0, PanelCol.Text )
			local state = IsValid(self) and self:GetChessState()
			if not (IsValid( self ) and state) then
				draw.SimpleText( "[N/A]", "ChessTextSmall", w/2, h/2, PanelCol.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				local str = (state==CHESS_WAGER and "Wagers") or (state==CHESS_INACTIVE and "Waiting") or ((state==CHESS_WHITEMOVE or state==CHESS_WHITEPROMO) and "White") or ((state==CHESS_BLACKMOVE or state==CHESS_BLACKPROMO) and "Black") or "N/A"
				local col = (str=="White" and PanelCol.White) or (str=="Black" and PanelCol.Black) or PanelCol.Text
				draw.SimpleText( str, "ChessTextLarge", w/2, h/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		
		local ButtonPanel = vgui.Create( "DPanel", frame )
		ButtonPanel:SetSize( 200, 20 )
		ButtonPanel:Dock( BOTTOM )
		ButtonPanel.Paint = function() end
		
		frame.OfferDraw = vgui.Create( "DButton", ButtonPanel)
		frame.OfferDraw:SetSize(94,20)
		frame.OfferDraw:Dock( LEFT )
		frame.OfferDraw:SetText( "Offer Draw" )
		frame.OfferDraw.DoClick = function( s )
			if (IsValid(self)) and not (self:GetPlaying()) then
				chat.AddText( Color(150,255,150), "You can't offer a draw before the game starts!" )
				return
			end
			net.Start( "Chess DrawOffer" ) net.SendToServer()
			s:SetText( "Draw offered" )
		end
		
		local Resign = vgui.Create( "DButton", ButtonPanel)
		Resign:SetSize(94,20)
		Resign:Dock( RIGHT )
		Resign:SetText( "Resign" )
		Resign.DoClick = function( s )
			net.Start( "Chess ClientResign" ) net.SendToServer() --No client-side exit func :/
		end
		
		local DrawButtonPanel = vgui.Create( "DPanel", frame )
		DrawButtonPanel:SetSize( 200, 20 )
		DrawButtonPanel:Dock( BOTTOM )
		DrawButtonPanel.Paint = function() end
		
		local MoveLimit = vgui.Create( "DButton", DrawButtonPanel)
		MoveLimit:SetSize(94,50)
		MoveLimit:Dock( LEFT )
		--MoveLimit:Dock( FILL )
		MoveLimit:SetText( "Call 50 moves" )
		MoveLimit.DoClick = function( s )
			net.Start( "Chess ClientCallDraw" )
				net.WriteUInt( CHESS_DRAW_50, 2 )
			net.SendToServer()
		end
		MoveLimit:SetEnabled( false )
		MoveLimit.Think = function( s )
			MoveLimit:SetEnabled( IsValid(self) and self:GetMoveCount()>=50 )
		end
		
		local Repetition = vgui.Create( "DButton", DrawButtonPanel)
		Repetition:SetSize(94,50)
		Repetition:Dock( RIGHT )
		Repetition:SetText( "Call Repetition" )
		Repetition.DoClick = function( s )
			net.Start( "Chess ClientCallDraw" )
				net.WriteUInt( CHESS_DRAW_3, 2 )
			net.SendToServer()
		end
		Repetition:SetEnabled( false )
		Repetition.Think = function( s )
			Repetition:SetEnabled( IsValid(self) and self:GetRepetition() )
		end
		
		return frame
	end

	local IsInChess, ScreenPos, ScreenAng, ActiveBoard
	local function ChessSeatCam( ply, pos, ang, fov, nearz, farz )
		
		local seat = ply:GetVehicle()
		if (IsValid(seat) and seat:GetNWBool("IsChessSeat",false)) or ply:GetNWBool( "IsInChess", false ) then
			ActiveBoard = IsValid(seat) and seat:GetNWEntity( "ChessBoard" )
			if not IsValid(ActiveBoard) then ActiveBoard = ply:GetNWEntity( "ActiveChessBoard" ) end
			if not IsValid(ActiveBoard) then return end
			
			if not IsValid(ChessPanel) then
				ChessPanel = IsValid(ActiveBoard.ChessPanel) and ActiveBoard.ChessPanel or ActiveBoard:CreateChessPanel() --Autorefresh fix
				ActiveBoard.ChessPanel = ChessPanel
			end
			
			local ViewPos = ActiveBoard:GetPos()+Vector(0,0,30) + (IsValid(seat) and seat:GetRight()*15 or ply:GetForward()*-15) --pos+Vector(0,0,20)+ (IsValid(seat) and seat:GetRight()*-15 or ply:GetForward()*15)
			local ViewAng = (ActiveBoard:GetPos()-ViewPos):Angle()
			if input.IsKeyDown( KEY_LALT ) then
				ViewAng = ang
				gui.EnableScreenClicker(false)
			else
				gui.EnableScreenClicker(true)
				if IsValid( ActiveBoard:GetTableEnt() ) and ActiveBoard:GetTableEnt():GetModel()==ActiveBoard.Models["hl2table"] then
					local tbl = ActiveBoard:GetTableEnt()
					local height = tbl:OBBMaxs()[3]-tbl:OBBMins()[3]
					ViewAng = ((tbl:GetPos()+Vector(0,0,height-10))-ViewPos):Angle()
				end
			end
			local view = {
				origin = ViewPos,
				angles = ViewAng,
				fov = fov,
				znear = nearz,
				zfar = farz,
				drawviewer = true,
			}
			
			IsInChess = true
			ScreenPos = ViewPos
			ScreenAng = ViewAng
			
			return view
		elseif IsInChess then --Exit
			if IsValid( ChessPanel ) then ChessPanel:Remove() end
			if IsValid( WagerPanel ) then WagerPanel:Remove() end
			gui.EnableScreenClicker(false)
			
			IsInChess = false
			ScreenPos = nil
			ScreenAng = nil
			ActiveBoard = nil
		else --Not in seat, and not just exited. Don't disable mouse here
			if IsValid( ChessPanel ) then ChessPanel:Remove() end
			if IsValid( WagerPanel ) then WagerPanel:Remove() end
			IsInChess = false
			ScreenPos = nil
			ScreenAng = nil
			ActiveBoard = nil
		end
		
	end
	hook.Add( "CalcView", "ChessBoardSeatCam", ChessSeatCam ) --CalcVehicleView doesn't work
	
	function ENT:ResetHighlights()
		self.Highlight = {-1,-1}
		self.Selected = {-1,-1}
		self.Moves = {}
	end
	
	function ENT:GetTraceFilter()
		local tbl = {}
		
		for GridLet,column in pairs( self.Pieces ) do
			for GridNum,square in pairs( column ) do
				if (IsValid( square.Ent )) then table.insert( tbl, square.Ent ) end
			end
		end
		
		return tbl
	end
	
	local ColHover,ColText,ColSel = Color(0,255,0,50),Color(50,50,50,200),Color(150,50,50,150)
	local ColBlack,ColWhite,ColMove = Color(0,0,0,120),Color(255,255,255,10),Color(50,50,150,150)
	function ENT:Draw()
		if (self.LastReScaleTime or 0)+10<CurTime() then self:EnableMatrix("RenderMultiply", ChessScale) self.LastReScaleTime=CurTime() end
		
		if not self.PiecesEnts then
			self.PiecesEnts = {}
			for i=1,16 do
				self.PiecesEnts[i] = ClientsideModel( self.Models["WhitePawn"] )
				self.PiecesEnts[i]:SetNoDraw( true )
				self.PiecesEnts[i]:EnableMatrix( "RenderMultiply", ChessScale )
			end
		end
		
		if FrameTime()>=0.33 and not self.SpectatingTable then --Less than 30 fps
			if self.FPSFailTimeout and self.FPSFailTimeout<CurTime() then
				self.FPSFailCount = 0
			end
			
			if (not self.FPSNextCheck) or self.FPSNextCheck<=CurTime() then
				self.FPSNextCheck = CurTime()+0.1
				self.FPSFailTimeout = CurTime()+2
				self.FPSFailCount = (self.FPSFailCount or 0)+1
				if self.FPSFailCount>=30 then
					self.LowFPSCheck = CurTime()+5
				end
			end
		end
		local InChessGame = (IsValid(LocalPlayer():GetVehicle()) or LocalPlayer():GetNWBool("IsInChess",false))
		
		if InChessGame or self.SpectatingTable or (not (self.LowFPSCheck and self.LowFPSCheck>CurTime())) then
			local i=0
			for let,column in pairs( self.Pieces ) do
				for num,square in pairs( column ) do
					if not (square.Team and square.Class) then continue end
					i=(i or 0)+1
					local pos = self:GetSquarePos( let, num )
					
					if square.Moving and square.MoveStart then
						local delta = math.Clamp( (RealTime()-square.MoveStart)/self.MoveTime, 0,1 )
						if delta==1 or (not delta) then
							square.Moving = false
							sound.Play( self.MoveSound, pos )
						else
							local Height = (delta*6)>=3 and (6-(delta*6)) or (delta*6)
							pos = Vector(
								square.MoveFrom[1] + (pos[1]-square.MoveFrom[1])*delta,
								square.MoveFrom[2] + (pos[2]-square.MoveFrom[2])*delta,
								pos[3] + Height
							)
						end
					end
					
					if not IsValid( self.PiecesEnts[i] ) then
						self.PiecesEnts[i] = ClientsideModel( self.Models["WhitePawn"] )
						self.PiecesEnts[i]:SetNoDraw( true )
						self.PiecesEnts[i]:EnableMatrix( "RenderMultiply", ChessScale )
					end
					if self.PiecesEnts[i]:GetPos()~=pos then self.PiecesEnts[i]:SetPos( pos ) end
					if self.PiecesEnts[i]:GetModel()~=self.Models[ square.Team .. square.Class ] then
						self.PiecesEnts[i]:SetModel( self.Models[ square.Team .. square.Class ] )
					end
					self.PiecesEnts[i]:DrawModel()
					if self.DrawDouble and self.DrawDouble[ square.Class ] then
						self.PiecesEnts[i]:SetModel( self.Models[ "dama" ] ) --Prevents invisible pieces
						self.PiecesEnts[i]:SetModel( self.Models[ square.Team .. square.Class ] ) 
						self.PiecesEnts[i]:SetPos( pos + Vector(0,0,(self.PiecesEnts[i]:OBBMaxs()[3]-self.PiecesEnts[i]:OBBMins()[3])*0.1225) )
						self.PiecesEnts[i]:DrawModel()
					end
				end
			end
		end
--		self.PiecesEnt:SetNoDraw( true )
		self:DrawModel()
		
		if not InChessGame then
			self.Highlight = nil
			self.Selected = nil
			self.Moves = nil
			return
		end
		
		self.Highlight = self.Highlight or {-1,-1}
		self.Selected = self.Selected or {-1,-1}
		self.Moves = self.Moves or {}
		local IsMouseDown = input.IsMouseDown( MOUSE_LEFT )
		local MouseClick = IsMouseDown and (not self.WasMouseDown)
		if ActiveBoard==self then --Don't need an IsValid check, we're valid
			self.Highlight[1]=(-1) self.Highlight[2]=(-1)
			local x,y = gui.MouseX(), gui.MouseY()
			
			local Target = ScreenPos + (gui.ScreenToVector( x, y )*10000)
			
			local tr = util.TraceLine( {start=ScreenPos, endpos=Target, filter=self:GetTraceFilter()} )
			
			local pos = self:WorldToLocal( tr.HitPos )
			local x,y = -1,-1
			if pos[2]>self.TopLeft[2] and pos[3]>self.TopLeft[3] then
				for i=0,8 do --Fall off the top
					if pos[2]<(self.TopLeft[2]+(self.RealW*i)) then break end
					y = i
				end
				for i=0,8 do
					if pos[3]<(self.TopLeft[3]+(self.RealH*i)) then break end
					x = i
				end
			end
			self.Highlight = {x,y}
			if MouseClick then
				if self.Selected and self:GetTableGrid( self.Moves, x, y ) then
					self:RequestMove( self.Selected[1], self.Selected[2], x, y )
					self:ResetHighlights()
				else
					self:ResetHighlights()
					self.Selected = {x,y}
					self.Moves = self:GetMove( NumToLetter[x+1], 8-y )
				end
			end
		else
			self.Selected[1]=(-1) self.Selected[2]=(-1)
			self.Highlight[1]=(-1) self.Highlight[2]=(-1)
			self.Moves = {}
			return
		end
		
		local pos = self:LocalToWorld( self.TopLeft )
		local ang = self:GetUp():Angle()
		
		cam.Start3D2D( pos, ang, 0.2 )
			for i=0,7 do
				for n=0,7 do
					local square = self:GetTableGrid( self.Pieces, i,n )
					if square and IsValid(square.Ent) then
						draw.RoundedBox( 0, self.SquareW*i, self.SquareH*n, self.SquareW, self.SquareH, square.Ent:GetWhite() and ColWhite or ColBlack )
					end
					if self.Highlight[1]==i and self.Highlight[2]==n then
						draw.RoundedBox( 0, self.SquareW*i, self.SquareH*n, self.SquareW, self.SquareH, ColHover )
					end
					if self:GetTableGrid( self.Moves, i, n ) then
						draw.RoundedBox( 0, self.SquareW*i, self.SquareH*n, self.SquareW, self.SquareH, ColMove )
					end
					if self.Selected[1]==i and self.Selected[2]==n then
						draw.RoundedBox( 0, self.SquareW*i, self.SquareH*n, self.SquareW, self.SquareH, ColSel )
					end
					if cvars.Bool("developer") then
						draw.SimpleText( NumToLetter[i+1]..tostring(8-n), "Default", self.SquareW*i, self.SquareH*n )
					end
				end
			end
		cam.End3D2D()
		
		self.WasMouseDown = input.IsMouseDown( MOUSE_LEFT )
	end
	
	function ENT:GetSpectateUse(ply,key)
		if ply~=LocalPlayer() then return end
		if key~=IN_USE then return end
		
		if CurTime()<(self.Spec_LastPoll or 0)+1 then return end
		self.Spec_LastPoll = CurTime()
		
		local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*150)} )
		if (tr.Entity==self:GetTableEnt()) then
			if not self.SpectatingTable then chat.AddText( HatsChat and {"LINEICON", Icon=Material( "icon16/controller.png" )} or "", Color(150,255,150), "You are now spectating this game." ) end
			self.SpectatingTable = true
		else
			if self.SpectatingTable then chat.AddText( HatsChat and {"LINEICON", Icon=Material( "icon16/controller.png" )} or "", Color(150,255,150), "You are no longer spectating this game." ) end
			self.SpectatingTable = false
		end
	end
	
	net.Receive( "Chess DrawOffer", function()
		if IsValid( ChessPanel ) and IsValid( ChessPanel.OfferDraw ) then
			ChessPanel.OfferDraw:SetText( "Accept Draw Offer" )
		end
	end)
	
	net.Receive( "Chess GameOver", function() --Now used for all messages
		local tbl = net.ReadTable()
		local emote = net.ReadString()
		if HatsChat then
			local Mat
			if emote and emote~="" then Mat = Material(emote) end
			if not Mat then
				Mat = Material( "icon16/controller.png" )
			end
			if tostring(Mat)~="___error" then
				table.insert(tbl, 1, {"LINEICON", Icon=Mat} )
			end
		end
		chat.AddText( unpack( tbl ) )
	end)
	net.Receive( "Chess PromotionSelection", function()
		local File = net.ReadInt( 5 )
		local Frame = vgui.Create( "DFrame" )
		Frame:SetSize( 100, 225 )
		Frame:SetPos( (ScrW()/2) - 50, (ScrH()/2)-112 )
		Frame:SetDraggable( false )
		Frame:ShowCloseButton( false )
		Frame:DockMargin( 5,5,5,5 )
		Frame:DockPadding( 5,5,5,5 )
		Frame:MakePopup()
		Frame:SetTitle( "" )
		Frame.Paint = function( s,w,h )
			draw.RoundedBox( 4, 0, 0, w, h, Color(0,0,0,150) )
		end
		
		local Queen = vgui.Create( "DButton", Frame )
		Queen.DoClick = function( s )
			net.Start( "Chess PromotionSelection" )
				net.WriteString( "Queen" )
				net.WriteInt( File, 5 )
			net.SendToServer()
			Frame:Remove()
		end
		Queen:SetText( "Ферзь" )
		Queen:Dock( TOP )
		Queen:SetSize( 90, 50 )
		Queen:DockMargin( 0,0,0,0 )
		
		local Rook = vgui.Create( "DButton", Frame )
		Rook.DoClick = function( s )
			net.Start( "Chess PromotionSelection" )
				net.WriteString( "Rook" )
				net.WriteInt( File, 5 )
			net.SendToServer()
			Frame:Remove()
		end
		Rook:SetText( "Ладья" )
		Rook:Dock( TOP )
		Rook:SetSize( 90, 50 )
		Rook:DockMargin( 0,5,0,0 )
		
		local Bishop = vgui.Create( "DButton", Frame )
		Bishop.DoClick = function( s )
			net.Start( "Chess PromotionSelection" )
				net.WriteString( "Bishop" )
				net.WriteInt( File, 5 )
			net.SendToServer()
			Frame:Remove()
		end
		Bishop:SetText( "Слон" )
		Bishop:Dock( TOP )
		Bishop:SetSize( 90, 50 )
		Bishop:DockMargin( 0,5,0,0 )
		
		local Knight = vgui.Create( "DButton", Frame )
		Knight.DoClick = function( s )
			net.Start( "Chess PromotionSelection" )
				net.WriteString( "Knight" )
				net.WriteInt( File, 5 )
			net.SendToServer()
			Frame:Remove()
		end
		Knight:SetText( "Конь" )
		Knight:Dock( TOP )
		Knight:SetSize( 90, 50 )
		Knight:DockMargin( 0,5,0,0 )
	end)
	
	net.Receive( "Chess Update", function()
		local board = net.ReadEntity()
		local pieces = net.ReadTable()
		
		local Move1 = net.ReadTable()
		local Move2 = net.ReadTable()
		
		if IsValid(board) and pieces then
			board.Pieces = pieces
			if Move1.To then
				if Move1.From then
					board.Pieces[Move1.To[1]][Move1.To[2]].Moving = true
					board.Pieces[Move1.To[1]][Move1.To[2]].MoveStart = RealTime()
					board.Pieces[Move1.To[1]][Move1.To[2]].MoveFrom = board:GetSquarePos( Move1.From[1],Move1.From[2] )
				else
					sound.Play( board.MoveSound, board:GetSquarePos( Move1.To[1],Move1.To[2]) or board:GetPos() )
				end
			end
			if Move2.To then
				if Move2.From then
					board.Pieces[Move2.To[1]][Move2.To[2]].Moving = true
					board.Pieces[Move2.To[1]][Move2.To[2]].MoveStart = RealTime()
					board.Pieces[Move2.To[1]][Move2.To[2]].MoveFrom = board:GetSquarePos( Move2.From[1],Move2.From[2] )
				else
					sound.Play( board.MoveSound, board:GetSquarePos( Move2.To[1],Move2.To[2]) or board:GetPos()  )
				end
			end
		end
	end)
end
if SERVER then
	net.Receive( "Chess ClientRequestMove", function(len, ply)
		if not IsValid(ply) then return end
		local seat = ply:GetVehicle()
		if not (IsValid(seat) and seat:GetNWBool("IsChessSeat", false)) then return end
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		local IsWhite = (seat==board.WhiteSeat)
		if (not IsWhite) and seat~=board.BlackSeat then return end
		
		if (not cvars.Bool( "chess_debug" )) and ((IsWhite and board:GetChessState()~=CHESS_WHITEMOVE) or ((not IsWhite) and board:GetChessState()~=CHESS_BLACKMOVE)) then return end
		
		local StartLet, StartNum =	NumToLetter[math.Clamp(net.ReadInt(5),1,8)], math.Clamp(net.ReadInt(5),1,8)
		local EndLet, EndNum =		NumToLetter[math.Clamp(net.ReadInt(5),1,8)], math.Clamp(net.ReadInt(5),1,8)
		
		local StartSquare = board:GetSquare( StartLet, StartNum )
		if not StartSquare then return end
		
		if (not cvars.Bool( "chess_debug" )) and ((IsWhite and board:SquareTeam(StartSquare)~="White") or ((not IsWhite) and board:SquareTeam(StartSquare)~="Black")) then return end
		
		board:DoMove( StartLet, StartNum, EndLet, EndNum )
	end)
	
	net.Receive( "Chess ClientResign", function( len,ply ) if IsValid(ply) then
		ply.CanExitChess = true
		ply:ExitVehicle()
	end end)
	net.Receive( "Chess DrawOffer", function( len,ply )
		if not IsValid(ply) then return end
		local seat = ply:GetVehicle()
		if not (IsValid(seat) and seat:GetNWBool("IsChessSeat", false)) then return end
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		local IsWhite = (seat==board.WhiteSeat)
		if (not IsWhite) and seat~=board.BlackSeat then return end
		
		if board.SurrenderOffer==(IsWhite and "Black" or "White") then
			local WhitePly = board:GetPlayer( "White" )
			local BlackPly = board:GetPlayer( "Black" )
			
			local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
			local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
			board:EndGame()
			ix.chat.Send(BlackPly, "chess", WhiteName .. " и " .. BlackName .. " согласились на ничью.")
		else
			board.SurrenderOffer = IsWhite and "White" or "Black"
			net.Start( "Chess DrawOffer" )
			net.Send( board:GetPlayer( IsWhite and "Black" or "White" ) )
		end
	end)
	net.Receive( "Chess ClientCallDraw", function( len,ply )
		if not IsValid(ply) then return end
		local seat = ply:GetVehicle()
		if not (IsValid(seat) and seat:GetNWBool("IsChessSeat", false)) then return end
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		local IsWhite = (seat==board.WhiteSeat)
		if (not IsWhite) and seat~=board.BlackSeat then return end
		
		local DrawType = net.ReadUInt( 2 )

		if DrawType==CHESS_DRAW_50 then
			if board:GetMoveCount()<50 then ply:ChatPrint( "This option is available when 50 moves pass without a pawn move or capture." ) return end
			local WhitePly = board:GetPlayer( "White" )
			local BlackPly = board:GetPlayer( "Black" )
			
			local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
			local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
			board:EndGame()

			if IsWhite then
				ix.chat.Send(WhitePly, "chess", "50 ходов! "..WhiteName.." запрашивает ничью!")
			else
				ix.chat.Send(BlackPly, "chess", "50 ходов! "..BlackName.." запрашивает ничью!")
			end

		elseif DrawType==CHESS_DRAW_3 then
			if not board:GetRepetition() then ply:ChatPrint( "This option is avilable when the board is in the same position three times." ) return end
			local WhitePly = board:GetPlayer( "White" )
			local BlackPly = board:GetPlayer( "Black" )
			
			local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
			local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
			board:EndGame()
			if IsWhite then
				ix.chat.Send(WhitePly, "chess", "Трехкратное повторение! "..WhiteName.." запрашивает ничью!")
			else
				ix.chat.Send(BlackPly, "chess", "Трехкратное повторение! "..BlackName.." запрашивает ничью!")
			end
		end
	end)
	
	local PromotionClass = {["Queen"] = true, ["Bishop"] = true, ["Rook"] = true, ["Knight"] = true}
	net.Receive( "Chess PromotionSelection", function( len, ply )
		if not IsValid(ply) then return end
		local seat = ply:GetVehicle()
		if not (IsValid(seat) and seat:GetNWBool("IsChessSeat", false)) then return end
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		local IsWhite = (board:GetPlayer("White")==ply)
		if (not IsWhite) and (board:GetPlayer("Black")~=ply) then return end
		if (IsWhite and board:GetChessState()~=CHESS_WHITEPROMO) or ((not IsWhite) and board:GetChessState()~=CHESS_BLACKPROMO) then return end
		
		local GridNum = (IsWhite and 8) or 1
		
		local Class = net.ReadString()
		local GridLetter = NumToLetter[net.ReadInt(5)]
		if not (GridLetter and Class) then return end
		if not PromotionClass[Class] then return end
		
		local square = board:GetSquare( GridLetter, GridNum )
		if not square then return end
		if (IsWhite and board:SquareTeam( square )~="White") or ((not IsWhite) and board:SquareTeam( square )~="Black") then return end
		if square.Class~="Pawn" then return end
		
		if IsValid(square.Ent) then square.Ent:SetGridNum(-1) square.Ent:Remove() end
		
		square.Class = Class
		
		board:Update( {To={GridLet,GridNum}} )

		local IsCheck = board:CheckForCheck( board.Pieces, square.Team~="White" )
		local Checkmate = board:IsCheckmate( square.Team~="White" )
		if IsCheck and Checkmate then
			local WhitePly = board:GetPlayer( "White" )
			local BlackPly = board:GetPlayer( "Black" )
			
			local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
			local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
			board:EndGame( square.Team )

			if square.Team=="White" then
				ix.chat.Send(WhitePly, "chess", WhiteName .. " поставил мат " .. BlackName .. "!")
			else
				ix.chat.Send(BlackPly, "chess", BlackName .. " поставил мат " .. WhiteName .. "!")
			end
		elseif Checkmate then
			local WhitePly = board:GetPlayer( "White" )
			local BlackPly = board:GetPlayer( "Black" )
			
			local WhiteName = IsValid(WhitePly) and WhitePly:Nick() or "[Anonymous White]"
			local BlackName = IsValid(BlackPly) and BlackPly:Nick() or "[Anonymous Black]"
			board:EndGame()

			ix.chat.Send(WhitePly, "chess", "Пат! " .. WhiteName .. " и " .. BlackName .. " завершают ничьей!")
		else
			board:SetChessState( IsWhite and CHESS_BLACKMOVE or CHESS_WHITEMOVE )
		end
	end)
	hook.Add( "PlayerEnteredVehicle", "Chess PlayerEnter BeginGame", function( ply, seat )
		if not (IsValid(ply) and IsValid(seat)) then return end
		if not seat:GetNWBool("IsChessSeat", false) then return end
		
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		ply.CanExitChess = false
		ply:GodEnable()
		
		ply:SetNWBool( "IsInChess", true )
		ply:SetNWEntity( "ActiveChessBoard", board )
		
		local IsWhite = (seat==board.WhiteSeat)
		if (not IsWhite) and seat~=board.BlackSeat then return end
		if IsWhite then board:SetWhitePlayer( ply ) else board:SetBlackPlayer( ply ) end
		
		local OtherSeat = IsWhite and board.BlackSeat or board.WhiteSeat
		if (not IsValid(OtherSeat)) or OtherSeat==seat then return end
		
		local OtherPly = OtherSeat:GetDriver()
		if cvars.Bool( "chess_debug" ) or (IsValid( OtherPly ) and not board:GetPlaying()) then
			board:ResetBoard()
	
			board:SetPlaying( true )
			board:SetChessState( board.StartState )
			board:SetPSWager( false )
			board.WagerValue = nil
		end
	end)
	hook.Add( "CanExitVehicle", "Chess CanExitVehicle Anti-minge", function( seat, ply ) --Backwards :p
		if not (IsValid(ply) and IsValid(seat)) then return end
		if not seat:GetNWBool("IsChessSeat", false) then return end
		
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		if board:GetPlaying() and (not ply.CanExitChess) then return false end
	end)
	hook.Add( "PlayerLeaveVehicle", "Chess PlayerLeave ResignGame", function( ply, seat )
		if not (IsValid(ply) and IsValid(seat)) then return end
		if not seat:GetNWBool("IsChessSeat", false) then return end
		
		ply:SetPos( seat:GetPos() - (seat:GetForward()*10) )
		--ply:SetAngles( seat:GetAngles() ) --Doesn't work?
		ply:GodDisable()
		
		ply:SetNWBool( "IsInChess", false )
		ply:SetNWEntity( "ActiveChessBoard", nil )
		
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		if board:GetPlaying() and (not ply.CanExitChess) then
			timer.Simple(0, function() if IsValid(ply) and IsValid(seat) then ply:EnterVehicle(seat) end end)
			return false
		end
		
		local IsWhite = (seat==board.WhiteSeat)
		if (not IsWhite) and seat~=board.BlackSeat then return end
		if IsWhite then board:SetWhitePlayer( NULL ) else board:SetBlackPlayer( NULL ) end
		
		board:SetChessState( CHESS_INACTIVE )
		if not board:GetPlaying() then return end
		board:SetPlaying( false )
		
		local OtherSeat = IsWhite and board.BlackSeat or board.WhiteSeat
		if (not IsValid(OtherSeat)) or OtherSeat==seat then return end
		
		local OtherPly = OtherSeat:GetDriver()
		
		local PlyName = IsValid(ply) and ply:Nick() or "[N/A]"
		local OtherName = IsValid(OtherPly) and OtherPly:Nick() or (IsWhite and "[Anonymous Black]" or "[Anonymous White]")
		
		board:EndGame( IsWhite and "Black" or "White", true )

		ix.chat.Send(ply, "chess", PlyName .. " сдаётся!")

		board:SetChessState( CHESS_INACTIVE )
		board:SetPlaying( false )
		
		if IsValid( OtherPly ) then OtherPly:ExitVehicle() end
	end)
	hook.Add( "PlayerDisconnected", "Chess PlayerDisconnect ResignGame", function( ply, seat )
		if not (IsValid(ply)) then return end
		
		local seat = ply:GetVehicle()
		if not (IsValid(seat) and seat:GetNWBool("IsChessSeat", false)) then return end
		
		ply:SetNWBool( "IsInChess", false )
		ply:SetNWEntity( "ActiveChessBoard", nil )
		
		local board = seat:GetNWEntity( "ChessBoard" )
		if not IsValid(board) then return end
		
		local IsWhite = (seat==board.WhiteSeat)
		if (not IsWhite) and seat~=board.BlackSeat then return end
		if IsWhite then board:SetWhitePlayer( NULL ) else board:SetBlackPlayer( NULL ) end
		
		board:SetChessState( CHESS_INACTIVE )
		if not board:GetPlaying() then return end
		board:SetPlaying( false )
		
		local OtherSeat = IsWhite and board.BlackSeat or board.WhiteSeat
		if (not IsValid(OtherSeat)) or OtherSeat==seat then return end
		
		local OtherPly = OtherSeat:GetDriver()
		
		local PlyName = IsValid(ply) and ply:Nick() or "[N/A]"
		local OtherName = IsValid(OtherPly) and OtherPly:Nick() or (IsWhite and "[Anonymous Black]" or "[Anonymous White]")
		
		board:EndGame( IsWhite and "Black" or "White", true )

		ix.chat.Send(ply, "chess", PlyName .. " сдаётся!")

		board:SetChessState( CHESS_INACTIVE )
		board:SetPlaying( false )
		
		if IsValid( OtherPly ) then OtherPly:ExitVehicle() end
	end)
end
