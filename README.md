# Description Wiki Links

This repository contains scripts for [KoLMafia](https://github.com/kolmafia/kolmafia) that change the titles of various descriptions (item, effect, etc.) to link to the wiki for more information.

None of it was written by me.  Most of it was written by [balefull](https://github.com/balefull), with a [small edit by Erosion](https://kolmafia.us/threads/r28706-coldfront-wiki-still-linked-to-after-changes-made-in-r28705.30799/#post-177641) to use the [new wiki](https://wiki.kingdomofloathing.com/).

# Setup
First, if you have used Balefullʼs version, you need to uninstall it.  In the GCLI, run
```
svn delete desc_wikiLinks
```

Then download and install this script, in the KoLMafia GCLI, run
```
git checkout dhouck/kol-desc-wikilinks.git main
```

You might also need to turn off the built-in KoLMafia wiki setting
```
set relayAddsWikiLinks = false
```
Now you will get the standard item/effect/etc. descriptions, but the item names there will link to the wiki for more information.

# Bugs
I do not know of any bugs in this.  If you find any, please report them; I might or might not get around to fixing them any time soon, but I certainly wonʼt if I donʼt know about them.  Iʼm more likely to merge PRs but still no promises about doing that in a timely manner.
