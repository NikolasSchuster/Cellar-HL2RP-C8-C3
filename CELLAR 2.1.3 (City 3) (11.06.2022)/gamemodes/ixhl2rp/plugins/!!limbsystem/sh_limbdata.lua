-- HUMANOIDS
local tex_body = Material("clockwork/limbs/body.png")
local tex_head = Material("clockwork/limbs/head.png")
local tex_chest = Material("clockwork/limbs/chest.png")
local tex_stomach = Material("clockwork/limbs/stomach.png")
local tex_lleg = Material("clockwork/limbs/lleg.png")
local tex_rleg = Material("clockwork/limbs/rleg.png")
local tex_lram = Material("clockwork/limbs/larm.png")
local tex_rarm = Material("clockwork/limbs/rarm.png")


-- HUMAN MALE
local Male = ix.limb.New("male", tex_body)

Male:AddLimb("head", HITGROUP_HEAD, tex_head)
Male:AddLimb("chest", HITGROUP_CHEST, tex_chest)
Male:AddLimb("stomach", HITGROUP_STOMACH, tex_stomach)
Male:AddLimb("leftLeg", HITGROUP_LEFTLEG, tex_lleg)
Male:AddLimb("rightLeg", HITGROUP_RIGHTLEG, tex_rleg)
Male:AddLimb("leftHand", HITGROUP_LEFTARM, tex_lram)
Male:AddLimb("rightHand", HITGROUP_RIGHTARM, tex_rarm)

LDATA_HUMAN_MALE = Male:Register()


-- HUMAN FEMALE
local Female = ix.limb.New("female", tex_body)

Female:AddLimb("head", HITGROUP_HEAD, tex_head)
Female:AddLimb("chest", HITGROUP_CHEST, tex_chest)
Female:AddLimb("stomach", HITGROUP_STOMACH, tex_stomach)
Female:AddLimb("leftLeg", HITGROUP_LEFTLEG, tex_lleg)
Female:AddLimb("rightLeg", HITGROUP_RIGHTLEG, tex_rleg)
Female:AddLimb("leftHand", HITGROUP_LEFTARM, tex_lram)
Female:AddLimb("rightHand", HITGROUP_RIGHTARM, tex_rarm)

LDATA_HUMAN_FEMALE = Female:Register()
