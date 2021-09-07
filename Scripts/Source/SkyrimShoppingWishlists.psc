scriptName SkyrimShoppingWishlists hidden
{Managing wishlists}

function SaveToWishlist(string wishlist, int trackedItemsAndSpells) global
    int wishlistMap = GetWishlist(wishlist)
    JValue.retain(wishlistMap)
    Form[] formsBeingAdded = JFormMap.allKeysPArray(trackedItemsAndSpells)
    int i = 0
    while i < formsBeingAdded.Length
        Form theForm = formsBeingAdded[i]
        int currentCount = JFormMap.getInt(wishlistMap, theForm)
        int newCount = currentCount + JFormMap.getInt(trackedItemsAndSpells, theForm)
        JFormMap.setInt(wishlistMap, theForm, newCount)
        i += 1
    endWhile
    string fileName = SkyrimShoppingQuest.GetInstance().WISHLISTS_FOLDER + "\\" + wishlist + ".json"
    JValue.writeToFile(wishlistMap, fileName)
    JValue.release(wishlistMap)
    Debug.Notification("Saved " + wishlist + ".json")
endFunction

int function GetWishlist(string name) global
    string fileName = SkyrimShoppingQuest.GetInstance().WISHLISTS_FOLDER + "\\" + name + ".json"
    int wishlist = JValue.readFromFile(name)
    if ! wishlist
        wishlist = JFormMap.object()
    endIf
    return wishlist
endFunction

int[] function GetAllWishlists() global
    ; return JValue.readFromDirectory(SkyrimShoppingQuest.GetInstance().WISHLISTS_FOLDER, ".json")
    ; TODO
endFunction

string[] function GetWishlistNames() global
    ; Note: Unsure if this returns JUST the filename or includes the path, we'll find out!
    string[] fileNames = MiscUtil.FilesInFolder(SkyrimShoppingQuest.GetInstance().WISHLISTS_FOLDER, ".json")
    string[] wishlistNames = Utility.CreateStringArray(fileNames.Length)
    int i = 0
    while i < fileNames.Length
        wishlistNames[i] = StringUtil.Substring(fileNames[i], 0, StringUtil.Find(filenames[i], ".json") - 1)
        i += 1
    endWhile
    return wishlistNames
endFunction
