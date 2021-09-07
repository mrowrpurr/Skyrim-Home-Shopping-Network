scriptName SkyrimShoppingSpellEffect extends ActiveMagicEffect  

event OnEffectStart(Actor target, Actor caster)
    SkyrimShoppingQuest.GetInstance().ActivateShoppingSpell()
endEvent