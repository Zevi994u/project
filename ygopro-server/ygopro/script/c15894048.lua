--究極恐獣
function c15894048.initial_effect(c)
	--First attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FIRST_ATTACK)
	e1:SetCondition(c15894048.facon)
	c:RegisterEffect(e1)
	--Must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetCondition(c15894048.facon)
	c:RegisterEffect(e2)
	--Attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetCondition(c15894048.facon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Register at battle start
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c15894048.regop)
	c:RegisterEffect(e4)
end

function c15894048.facon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and e:GetHandler():GetFlagEffect(15894048)>0
end

function c15894048.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(15894048,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
