scriptName SkyrimShoppingActivelyShoppingEffect extends ActiveMagicEffect  
{This effect is only active when shopping}

event OnEffectStart(Actor target, Actor caster)
    Debug.Notification("Shopping time!")
    PO3_Events_AME.RegisterForSpellLearned(self)
endEvent

event OnEffectFinish(Actor target, Actor caster)
    Debug.Notification("Done shopping.")
    PO3_Events_AME.UnregisterForSpellLearned(self)
endEvent

event OnSpellLearned(Spell theSpell)
    SkyrimShoppingTripItemTracker.TrackAddedSpell(theSpell)
endEvent

event OnItemAdded(Form item, Int count, ObjectReference akItemReference, ObjectReference akSourceContainer)
    SkyrimShoppingTripItemTracker.TrackAddedItem(item, count)
endEvent

event OnItemRemoved(Form item, Int count, ObjectReference itemReference, ObjectReference newContainer)
    SkyrimShoppingTripItemTracker.UntrackItem(item, count, itemReference, newContainer)
endEvent
