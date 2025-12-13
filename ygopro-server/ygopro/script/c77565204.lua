--Future Fusion
function c77565204.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(function(e,tp)
        local mg=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) end,tp,LOCATION_DECK,0,nil,e)
        local sg=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(mg) end,tp,LOCATION_EXTRA,0,nil)
        for tc in aux.Next(sg) do
            if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then return true end
        end
        return false
    end)
    e1:SetOperation(function(e,tp)
        local c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        local mg=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) end,tp,LOCATION_DECK,0,nil,e)
        local sg=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(mg) end,tp,LOCATION_EXTRA,0,nil)
        local valid=Group.CreateGroup()
        for tc in aux.Next(sg) do if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then valid:AddCard(tc) end end
        if #valid==0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local fus=valid:Select(tp,1,1,nil):GetFirst()
        Duel.ConfirmCards(1-tp,fus)
        local code=fus:GetCode()
        local mat=Duel.SelectFusionMaterial(tp,fus,mg)
        fus:SetMaterial(mat)
        Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e2:SetRange(LOCATION_SZONE)
        e2:SetLabel(code)
        e2:SetCountLimit(1)
        e2:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
        e2:SetOperation(function(e,tp)
            local c=e:GetHandler()
            c:SetTurnCounter(c:GetTurnCounter()+1)
            if c:GetTurnCounter()<2 then return end
            local code=e:GetLabel()
            local g=Duel.GetMatchingGroup(function(tc) return tc:IsCode(code) end,tp,LOCATION_EXTRA,0,nil)
            local tc=g:GetFirst()
            if not tc then return end
            if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) or Duel.GetLocationCountFromEx(tp)<=0 then
                Duel.SendtoGrave(tc,REASON_EFFECT)
                tc:CompleteProcedure()
                return
            end
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            tc:CompleteProcedure()
            c:SetCardTarget(tc)
        end)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
        c:RegisterEffect(e2)
    end)
    c:RegisterEffect(e1)

    --Destroy linked fusion
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetOperation(function(e) local tc=e:GetHandler():GetFirstCardTarget() if tc and tc:IsLocation(LOCATION_MZONE) then Duel.Destroy(tc,REASON_EFFECT) end end)
    c:RegisterEffect(e3)

    --Destroy this card if fusion destroyed
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(function(e,tp,eg) local tc=e:GetHandler():GetFirstCardTarget() return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY) end)
    e4:SetOperation(function(e,tp) Duel.Destroy(e:GetHandler(),REASON_EFFECT) end)
    c:RegisterEffect(e4)
end