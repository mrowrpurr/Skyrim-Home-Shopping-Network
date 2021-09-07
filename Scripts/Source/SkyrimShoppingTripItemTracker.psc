scriptName SkyrimShoppingTripItemTracker hidden
{Tracks the spells and # of items added to the player during the current shopping trip}

function TrackAddedItem(Form item, int count) global
    SkyrimShoppingQuest.Log("Track Added Item " + count + "x " + item.GetName())
    int map = SkyrimShoppingQuest.GetInstance().CurrentShoppingSpreeInventoryItemTrackerMap
    int currentCount = JFormMap.getInt(map, item)
    JFormMap.setInt(map, item, currentCount + count)
endFunction

function UntrackItem(Form item, int count, ObjectReference instance, ObjectReference newContainer) global
    SkyrimShoppingQuest.Log("Untrack Added Item " + count + "x " + item.GetName())
    int map = SkyrimShoppingQuest.GetInstance().CurrentShoppingSpreeInventoryItemTrackerMap
    int currentCount = JFormMap.getInt(map, item)
    if currentCount > 0 && ! newContainer && instance
        ; Item was dropped into the world, delete it! If it was previously tracked. If untracked, go ahead and drop it into the world.
        instance.Delete()
    endIf
    int newCount = currentCount - count
    if newCount < 1
        JFormMap.removeKey(map, item)
    else
        JFormMap.setInt(map, item, newCount)
    endIf
endFunction

function TrackAddedSpell(Spell theSpell) global
    SkyrimShoppingQuest.Log("Track Spell Learned " + theSpell.GetName())
    int map = SkyrimShoppingQuest.GetInstance().CurrentShoppingSpreeInventoryItemTrackerMap
    JFormMap.setInt(map, theSpell, 1)
endFunction

function RemoveAllTrackedItemsAndSpellsFromPlayer() global
    Actor player = Game.GetPlayer()
    SkyrimShoppingQuest.Log("Removing All Tracked Items and Spells from Player")
    int map = SkyrimShoppingQuest.GetInstance().CurrentShoppingSpreeInventoryItemTrackerMap
    Form[] items = JFormMap.allKeysPArray(map)
    int i = 0
    while i < items.Length
        Form theForm = items[i]
        Spell theSpell = theForm as Spell
        if theSpell
            SkyrimShoppingQuest.Log("Removing " + theSpell.GetName() + " from player")
            player.RemoveSpell(theSpell)
        else
            int count = JFormMap.getInt(map, theForm)
            SkyrimShoppingQuest.Log("Removing " + count + "x " + theForm.GetName() + " from player")
            player.RemoveItem(theForm, count)
        endIf
        i += 1
    endWhile
endFunction
