scriptName SkyrimShoppingQuest extends Quest

; Messages for Menus
Message property CurrentlyShoppingMenu auto  
Message property ManageWishlistsMenu auto  
Message property NotCurrentlyShoppingMenu auto  
Message property ItemsOrSpellsMenu auto

; `Short` variable for sharing whether the player is currently shopping (default: false)
GlobalVariable property IsCurrentlyShoppingVariable auto  

; Get the Skyrim Shopping Quest
SkyrimShoppingQuest function GetInstance() global
    return GetModForm(0x800) as SkyrimShoppingQuest
endFunction

; Folder where wishlists are stored as .json files
; for interaction with Twitch bot
string property WISHLISTS_FOLDER = "Data\\SkyrimShopping\\Wishlists" autoReadonly

; Tracks spells or the # of items which have been added to
; the player during the shopping spree.
; Once shopping has ended, the items/spells will be removed from the player. 
; Tracks by storing [Form] ==> count
int property CurrentShoppingSpreeInventoryItemTrackerMap auto

; Helper to get a Form from SkyrimShopping.esp
Form function GetModForm(int formID) global
    return Game.GetFormFromFile(formID, "SkyrimShopping.esp")
endFunction

; Is the player currently shopping?
bool property IsCurrentlyShopping
    bool function get()
        return IsCurrentlyShoppingVariable.GetValueInt() == 1
    endFunction
    function set(bool value)
        if value
            IsCurrentlyShoppingVariable.SetValueInt(1)
        else
            IsCurrentlyShoppingVariable.SetValueInt(0)
        endIf
    endFunction
endProperty

; When the Lesser Power is activated, 
function ActivateShoppingSpell()
    if IsCurrentlyShopping
        ContinueShopping()
    else
        GoShopping()
    endIf
endFunction

; [Menu] Triggers message menu to start a new shopping trip (or manage wishlists)
function GoShopping()
    int goShopping = 0
    int manageWishlists = 1
    int result = NotCurrentlyShoppingMenu.Show()
    if result == goShopping
        IsCurrentlyShopping = true
        SetupNewShoppingTrip()
        Debug.MessageBox("Welcome to the Skyrim Home Shopping Network\n\nAny items or spells added will be considered as part of your wishlist.\n\nYou may drop items you don't want and they will be automatically cleaned up for you.\n\nWhen you are ready, use this Shout again and cancel your shopping trip or save items/spells to a new or existing wishlist.\n\nEnjoy your shopping!")
    elseIf result == manageWishlists
        Debug.MessageBox("TODO")
    endIf
endFunction

; [Menu] Triggers message menu to complete/cancel the current shopping trip (or manage wishlists)
function ContinueShopping()
    int viewBag = 0 ; Update for spells + items
    int saveToWishlist = 1
    int cancelTrip = 2
    int manageWishlists = 3
    int result = CurrentlyShoppingMenu.Show()
    if result == viewBag
        Debug.MessageBox("TODO")
    elseIf result == saveToWishlist
        SkyrimShoppingWishlists.SaveToWishlist("default", CurrentShoppingSpreeInventoryItemTrackerMap)
        SkyrimShoppingTripItemTracker.RemoveAllTrackedItemsAndSpellsFromPlayer()
    elseIf result == cancelTrip
        Debug.MessageBox("TODO")
    elseIf result == manageWishlists
        Debug.MessageBox("TODO")
    endIf
endFunction

; [Menu] Managing Wishlists
function ManageWishlists()
    int viewWishlist = 0
    int addToWishlist = 1
    int removeFromWishlist = 2
    int newWishlist = 3
    int deleteWishlist = 4
    int goBack = 5
    int result = ManageWishlistsMenu.Show()
endFunction

; [Menu] Choose 'Items' or 'Spells' to view in wishlist
function SelectItemsOrSpells()
    int viewItems = 0
    int viewSpells = 1
    int goBack = 2
    int result = ItemsOrSpellsMenu.Show()
endFunction

; Setup data tracking for a new shopping trip 
function SetupNewShoppingTrip()
    if (CurrentShoppingSpreeInventoryItemTrackerMap)
        JValue.release(CurrentShoppingSpreeInventoryItemTrackerMap)
        Log("Unexpected: Overwriting previous inventory tracking data!")
    endIf
    CurrentShoppingSpreeInventoryItemTrackerMap = JFormMap.object()
    JValue.retain(CurrentShoppingSpreeInventoryItemTrackerMap)
endFunction

; Logging function helper ~ use this, not Debug.Trace()
function Log(string text) global
    Debug.Trace("[Skyrim Shopping] " + text)
endFunction
