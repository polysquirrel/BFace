
1. Portrait grouping and locations.

All portrait files reside in two directory trees based on their purpose:
  - charname:	portraits for player characters only
  - npcs:	portraits for other game characters, including companions.

These trees have a fixed structure and depth, with each level grouping the 
portraits located beneath it based on a particular criteria. This structure is 
depended upon by the implementation to provide the user various installation
options and, unless stated otherwise, the directories must have fixed names, 
with unrecognized directories being ignored. Any part of the of the tree may
be missing if the particular mod version does not offer any portraits in that
category. In that case, the appropriate installation options will be generally
unavailable.  This is not clear-cut however, as the implementation doesn't 
actually check if any files are available and would be used by the game unless 
it has to. The general meaning of each level of the trie is as follows:

	<root>/<role>/<game>/<gender>/<portraitset>/<portrait>

where:
  
  - root:	the root directory, either 'npcs' or 'charname', specifying the
         	receipient of the portraits, the specific meaning of all 
         	subdirectories and how they are handled.
  
  - role:	different meaning for 'npcs' and 'charname', specified in detail
           	below. 
  
  - game:	the game to which the portrait belongs; for charname portraits 
                in most cases it is 'any' or an arbitrary grouping by source.
  
  - gender:	the gender of the character depicted, used to install the 
                portraits in the appropriate list at character generation.
  
  - portraiset: groups portraits which are always installed in tandem. Under 
                the NPC tree, it is always the name of the NPC and contains all 
		sizes of the particular portrait. For the charname tree, 
		it is more broad.

  - portrait:	the level where all installed portraits reside. Although there
                are some exceptions, they require special handling and portraits
		files lying elsewhere will not be found.






1.1 The NPC directory tree		

Contains the portraits dedicated to individual game characters and normally 
unavailable to the player. This includes both companions and other NPCs, in
particular also those without existing portraits in the game. 



1.1.1 NPC roles

The 'role' level can contain the following directories (any others will be 
ignored):

 - canonnpcs:	companions from unmodified games (including expansions, enhanced
                editions, etc.). 
  
 - modnpcs:	companions from fan modules.
  
 - plotnpcs:	NPCs who are crucial to the plot and already have portraits 
                in the games. Although the latter is not strictly required,
		it provides a logical choice of installation option.

 - bonusnpcs:	a catch-all group of portraits from the main artist who are
                neither companions nor plot NPCs, but should be offered during
                installation with higher priority than support npcs as they 
		offer the highest style consistency.

 - supportnpcs:	some of the most prominent non-controllable characters 
                in the games, such as bosses or recurring allies.
  
 - minornpcs:	quest givers and other characters from side-quests, usually 
                appearing only once.
  
 - extranpcs:	cast 'extras' who might have only a single line of dialogue.

 - unifiednpcs: a special directory with portraits patching returning npcs 
                to use the portrait files from the first game.



1.1.2 NPC games

Currently supported 'game' directories are: 'bgee', 'bg2ee', 'sod', 'any', where
the latter contains files used by all supported games (it is always included 
when copying files for the particular NPC role).

Ths level consists of directories grouping NPCs by their appearance. When 
an NPC is present in several games, they will have separate portraits under 
each corresponding directory. In particular, their portraits may be different
in different games and their names also usually differ. The exception here 
are expansions, which receive separate directories, but do not repeat the 
portraits from the base game. When installing in a game with an expansion (or
other combined versions such as EET), files from all relevant directories 
are used. In case several files with the same name are present when copying, 
they will overwrite each other in an unspecified order. The directories 
therefore correspond more to the content of a particular game than a 
installation in the sense of WeiDU 'GAME_IS' function.



1.1.3 NPC gender

Can be one of 'male', 'female' or 'other'

This groups the files by the gender of the character, so that, when being made
available to players' characters in addition to the NPC, they can be installed
to the appropriate list. This depends on installation options chosen, but the 
intent is that after having chosen the gender of the character, only the 
appropriate portraits are installed. The 'other' directory groups characters
whose portraits should be never offered to the players. This is used both in
the case of the most important NPCs to keep their unique appearance, and for
portraits which are not suitable for the PC due to other reasons, chief of 
which are being of a non-playable race (such as the goblin M'Khiin or Varshoon
the mind flayer), or age - it makes no sense to offer elderly portraits to 
a character supposed to be around 18 years old.



1.1.4 NPC portrait set

Sometimes refered to as the 'NPC' level or simply as 'name' in the code,
it contains files which are always copied in tandem.  The names of directories 
at this level are completely arbitrary, but should be the name of the NPC
depicted on the portrait, as they will contain all used resolutions of a single 
image. This is in no means necessary for the mod to opperate, but in some cases
the directory names are shown to the player with that assumption. Additionally,
several installation options refer to different appearances of a character
(such as offering CHARNAME the portraits of NPCs from other games) and this is 
based on the repeating directory names, as the file names for portraits of the 
same character differ between the games due to the portraits being different 
themselves. Directories of the same name are assumed to contain portraits of 
the same character, regardless of the 'role','game' and 'gender' directories 
they are placed under. In consequence, if the mod deviates from this assumption,
some options might not work as advertised.

The portrait sets for non-joinable NPCs (supportnpcs, minornpcs, extranpcs) can
deviate from this restriction as they would contain a single portrait anyway. 
Those that should be offered to player characters (providing the appropriate
decision is made during the installation) should be named the same as standard
portrait sets in the charname/unque tree (see 1.2.4).


1.1.5 Alternative potrait sets

A directory with a portrait set can have a special subdirectory 'alternatives'.
When present, it should contain multiple (more than one) subdirectories, each
representing different versions of the potrait for the same (parent) NPC. 
The portrait in the parent 'portraitset' should always be one of those versions,
with the best practice here having the main portraits as '.ref' files pointing
to the default version between the alternatives. If an appropriate option is 
selected during the installation, the user will be prompted to pick a single 
version to use. For this reason, each of the 'version' directories must contain
the files with the same name as the parent portrait set (more accurately, they 
should override all portraits from the default set which are actually used by 
the character in question). As the names of the directories are currently used 
for the names of the portrait set, they should accurately, but concisely, 
describe the portrait so that the user can recognize which portrait they refer
to, assuming they have seen them before. 






1.2 CHARNAME directory tree

The files for CHARNAME are likewise grouped in a 5-deep directory tree, but the 
functions of the levels are slightly different:

	charname/<role>/<bundle>/<gender>/<portraitset>



1.2.1 CHARNAME portrait role 

The purpose of directories at this level varies significantly more than simple
logical grouping as is the case in the 'npcs' tree. Each of the following
directoories is used in different scenario and for different options:

 - unique:	this is the 'main' directory, containing portraits reserved 
          	exclusively for CHARNAME and which are installed in the
		default manner, with no special handling. It is the only
		directory containing files installed directly.
 
 - override:	Contains portraits overriding existing files. This includes
           	in particular portraits reserved for CHARNAME but named after
		existing unused NPC portraits (such as BG1 portraits in BG2).
		Portraits from this directory are not installed directly;
		they are instead copied to the pool directory, where they
		are refered to by '.ref' files from the main 'unique' directory.
		This serves two purposes: a) deleting a file from the pool makes
		it automatically unavailable to the player by invalidating
		the reference, and b) the reference can be named differently to
		the overriden portrait, following the CHARNAME scheme in order
		to attain better file sorting, based on the type of character
		depicted on the overriding portrait.

 - npcs:	These in turn are portraits actually used by NPCs, which can
       		be granted to player characters if an appropriate option is
		selected during installation. Instead of simply using a 
		portrait as-is (and to pick the appropriate 'large' resolution),
		the files here are named according to the scheme used by
		CHARNAME poortraits (and all new portraits introduced by this 
		mod). They are matched with files of the same name in the NPC
		tree: when an option would grant PC the portrait of an NPC,
		this subdirectory is searched for a file with the same name
		as a file from the portrait set of that NPC. They will likely
		be the same '.ref' file pointing to the (differently named)
		main '.bmp' portrait of the NPC.

 - pool:	created during installation, it contains copies of the files
                from the override directory which are targets of reference
		files placed under 'unique' directory. Unlike other directories,
		it has a completely flat structure with all files residing
		directly under it. These portraits are never installed directly,
		but controlling which files are present in the pool when the 
		'unique' portraits are installed controlls which references 
		cannot be resolved and are not installed in the result. 
		At the same time, the reference files can be named differently 
		to the referenced portraits and follow the format for CHARNAME.



1.2.2 CHARNAME portrait bundles

As there isn't much benefit in offering different portraits to the CHARNAME in
different games, this directory level serves a completely different purpose.
Under the 'unique' directory, each directory here represents a group of 
portraits sharing some common characteristic (generally, the painting style 
or appearance), installed together. The user can decide to install only selected
bundles based on their preferences and expectations. The directories should 
have user-friendly, concise, but informative, names - they are displayed
to the user in the command prompt when offering the choice of their 
installation. Due to a weidu limitation, they can not currently contain spaces.

Under other directories, directories at this level are all treated equally
without any options to select between them. Usually, it contains a single 'any'
directory to facilitate code reuse with the NPC tree. Alternatively, the mod 
may use it as it sees fit, for example to group portraits by artists or source.



1.2.3 CHARNAME gender

This is the same as under the NPC tree, with the exception that only 'male' and
'female' directories are used. Each of them contains files which are installed 
to the separate lists for the gender presented on the character generation 
screen.



1.2.4 CHARNAME portrait set

As there is no requirement to match the portraits of the same character between games and the files are installed in larger bundles, there is no real need for
the directories at this level to contain a single portrait - in fact, as 
enhanced editions resize the portraits themselves and do not require different
sizes, they group the portraits based on broader criteria.

For the 'unique' subtree, they should group featured characters by a distinctive
trait. It is arbitrary to an extent, although certain names are treated
specially:

 -default:	These portraits are always installed when the parent bundle is
           	chosen.
 
 -non-playable:	Portraits of races which cannot be picked during character 
         	generation, such as Drow and Tieflings. 
 
 -old:          Portraits of characters much older than the backstory suggests.

 -cameos:	Portraits of recognisable characters - from films, other games,
         	or alternative depictions of game characters by other artists.

By convention, to make coding somewhat easier, all other portraits reside in a
directory named simply 'portraits'.


For the 'override' subtree, the directory names are fixed and reflect which 
group of portraits they override:

 - defaults:	standard portraits available only to player characters

 - obe:     	portraits of illusory companions from Obe's training, which
           	straddle the line between the NPC and PC portraits from the
		players' point of view.

 - npcs:	files named after the portraits of NPCs, both used in the game
        	and not.









2. File name format.

Replacements for existing files are named after the replaced files. All 
new files start with a unique two-letter modder/module prefix. This is 
'BF' for Baldur's Face by default, but independent versions may use other
characters.



2.1 CHARNAME portraits

The portraits intended for player characters follow a strict, established naming
scheme. This is to guarantee uniqueness (which might be a problem with source
files residing in separate directories) and organisation, but also allows 
sorting which will place like portraits together on the character generation
screen, regardless of how are they grouped together in the mod. In particular,
portrait lists for all installed bundles are not simply concatenated, but
merged together preserving that order. With that in mind, as assigning a 
portrait to many of the categories - especially character class - is quite
arbitrary, the scheme is designed to minimise the distance between the positions
on the list which would result from categorizing the image in various viable 
alternatives. For example, dwarves, halflings and gnomes are so similar as 
to be often exchangable and are placed close together; they are also usually 
more similar to elves than humans, so they sort closer to the former than 
the latter. Currently, only the last letter is actually used by the mod implementation to determine the portrait size, although it isn't enforced to be one 
of the predefined choices either.

The file name format is thus defined as follows:

	<prefix><gender><race><class><id><size>.<extension>

where:

  - prefix: a fixed two character long module prefix to minimise the risk of 
            accidental overrides; by default 'BF' for 'Baldur's Face'.

  - gender: [F|M] standing for Female/Male;

  - race:   [D|G|H|E|M|O|W] for Dwarf/Gnome/Halfling/Elf/huMan/half-Orc/droW.
            Additionally, some portraits of non-playable races may be made 
	    available to players on request during installation for role-playing
	    or visual reasons. In that case they will follow the extended 
	    format used for NPCs, as described in the next subsection.

  - class:  [A|B|C|F|K|M|R|S|T|W] being shorthand for class proxies:
            Any/Bard/Cleric/Fighter/Knight/Monk/Ranger/Shaman/Thief/Wizard
            - Any is used whenever a portrait has no defined features which 
              would favour one occupation over another;  
            - Fighters are those with lighter armour, in particular including
              barbarians;
            - Knights are fighters in heavy (plate) armour, in particular
              including most paladins (whose features don't make them evidently
              Cleric-like)
            - Rangers are fighters in medium armour, usually in muted colours 
              and/or cloaked;
            - Shamans include druids and other unwashed weirdos;
            - Thieves are typically hooded and have an untrustworthy look;
            - Wizards displaying magic or just wearing fancy robes.

  - id:    two characters unique for all the portraits belonging to the same
           categories (having the same prefix up to this point). It is generally
	   further divided into first character (which should be a digit if 
	   possible) being unique to a portrait bundle, and the second 
	   character, from the [0-9A-Z] range, for different portraits in the
	   same bundle.

	     
  - size:       A single character defining the resolution and use in game.
                The resolutions for classic Baldur's Gate games are:
                - L: 210x330
                - M: 110x170
                - S: 38x60
                For Enhanced Editions these are:
                - L: 210x330
                - M: 169x266
	        - S: 54x84
	        Note however, that later patches of Enhanced Editions will 
                resize any image to fit the screen and there may be limited 
		benefit in offering tailored sizes. In particular, size 'S' 
                seems to be no longer used. For this reason, offering a single
                portrait of any resolution no wider than 1024 pixels 
		is generally sufficient and by default only the highest
                resolution image is actually installed ('L' or 'G'). The 
                exception here is that if both 'L' and 'M' portrait files are
                present, the mod will install them as a pair. This allows having
                a different framing as in IWD (or a different portrait 
                altogether). Currently however the game will only use the 'L' 
                portrait for the BG2 epilogue unless modded.

  - extension: [bmp|ref] - the latter begin a referernce to a portrait file,
               descriptions of which follow.



2.2 NPC portraits

Portraits for characters already having portraits, be it from the standard game
or mods, are obviously named after the files they override. New portraits start
all with a 'BF' prefix for 'Baldur's Face'. Humanoid characters generally
follow the scheme for CHARNAME with extensions allowing for more races and
occupations:

  - gender:  [B|F|G|M] with new Boy/Girl designators;

  - race:    [D|G|H|E|M|O|R|T|W] with new R, T standing for ogRe and Tiefling,
             the latter including also Cambions (and potentially humanoid demons
             and devils), with the gender being the discriminator. They may be 
             also optionally offered to players, depending on installation 
             choices.
  
  - class:   [A|B|C|F|G|K|M|N|P|R|S], the new characters standing for 
             Guard/Noble/Peasant.
  
  - id:      does not change from the CHARNAME format and naturally must remain
             unique between CHARNAME and NPC portraits. NPC portraits will 
	     generally have a letter as the first character designed to group
             the files either by source (artist) or role. This is in no way
             interpreted however and serves only to make maintaining uniqueness
             of file names easier.	     

  - size:    The only interpreted letters are the standard three [L|M|S] with an
             addition of 'G' oft used as to denote the largest portrait by mods.
	     Additionally, non-joinable characters in Enhanced Editions can
	     use one of easily scaled resolutions:
             - N: 140x220
             - O: 126x198
             - P: 110x173
             - Q: 100x157
	     - R: 90x140
	     Portraits ending in letters other than 'L' and 'G' will never
             be offered to CHARNAME, regardless of the chosen installation
	     options. The only exception is an accompanying 'M' portrait
             with the same file name prefix as an existing 'L' version.	     
	     With smaller resolutions it is generally advisable to resize and 
             sharpen manually to 54x84, although files can use 'X' to denote
	     a non-standard, small format. Resolutions larger than 'L' should 
	     use a letter before 'G'. This information is for the modders 
	     convenience solely and currently not used in any way (although
	     it might if new functionality is implemented, such as automatic
	     resizing and sharpening of images).


Other NPCs should try to stick to the established format by expanding one of the
categories if possible. If not - or for easier identification of portraits of
prominent characters - the file name is allowed to differ on the whole middle
section between the module prefix and the size letter, but differ from a file 
name legal in the established scheme at least on the 'gender' letter.









3. File types.

Apart from module code residing outside the listed top-level directories, all files must have one of the following
extension, depending on their contents and format:

 - .bmp:        self explanatory, image files to be used by the game.

 - .2da:        list of game creatures receiving a given portrait file. 
                The file must reside next to portrait files in
        	in a directory on the 'npc' level, and its base name must be 
                the same as that of one of one of the neighour portrait files. 
                Each line should contain a creature code (creature file name 
                to patch). If the portrait file name (and base name of this 
                file) ends with 'S', it is used as the small portrait for the 
                creature and, if either a matching 'M' or 'L' (in that search 
                order) file is also found, it is used for the large portrait. 
                Similarly, if the file name ends with 'M', and an 'L' file 
                exists in the same directory, the former is used for the small 
                portrait and the latter for the large portrait. Otherwise 
                the matching portrait file is used as both the large and small 
                portraits.

 - .ref:        a 'symbolic link' to a single portrait file and recognised by 
                the module. It must contain a single line
        	containing a path to a portrait file, relative to the top-level
                module directory (src in the repository). It might or might not
                contain the file extension, but must point to either a 'bmp' or
                another 'ref' file. When encountered, the target file is copied
                instead of the reference, but the name of the reference is
        	used as the final portrait name rather than that of the copied 
                file. This feature is used to avoid having several copies of 
                a single file, or to rename a file, depending on the context of
                use.

 - .refs:       similar to '.ref', it contains a list of portraits to be copied
                in place of the 'refs' file. Each line denotes a single file 
                and should contain two columns, separated by a 'tab' character.
                The first is the final name of the file after copying, without 
                an extension. The second must be the path to the copied file, 
                as in a '.ref' file.


