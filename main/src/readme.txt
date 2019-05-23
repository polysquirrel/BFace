1. Portrait groups and locations.

All portrait files reside in several directory trees based on their purpose:
  - canonnpcs:	companions from unmodified games (including expansions, EE, etc.). 
  - modnpcs:	companions from fan modules.
  - plotnpcs:	NPCs who are crucial to the plot and already have portraits in the games.
  - majornpcs:	some of the most prominent non-controllable characters in the games, such as bosses or recurring allies.
  - minornpcs:	quest givers and other characters from side-quests, usually appearing only once.
  - extranpcs:	cast 'extras' who might have only a single line of dialogue.
  - unifiednpcs:special directory with portraits patching returning npcs to use 
                the portrait files from the first game.
  - charname:	portraits for the player character.

The style consistency of portraits will generally decrease together with the prominence of a character: extranpcs will 
vary considerably more than majornpcs for example. The user has the option of installing selected portrait groups only.



2. NPC directory structure.

With a few exceptions, the portraits will always reside in directories 3 levels below the root portrait group directory.
Intermediate directories group them based on their application and are used by the module code to offer installation
options. The path to a npc portrait file is interpreted as follows:

	src/<group>/<game>/<gender>/<npc>/file.bmp

where:
  - group:	one of the listed top-level npc/pc portrait groups
  - game:	the shortened game name: bg1ee, bg2ee, sod. ToB and TotSC are included in the base games. Used explcitly 
           	by the module code to select the proper portraits for a given game.
  - gender:	male/female/other. The last one serves to explicitly exclude a portrait from use by the pc, even if an
           	appropriate installation option is selected.
  - npc:	the name of the NPC present on the portraits. Human readable, used for logging purposes and displayed to 
         	the user in certain cases. Not interpreted by module code.

In addition, next to the portrait files, a special directory 'alternatives' may reside, containing alternate versions
of the portraits when multiple are available. Each subdirectory should have a descriptive name pointing out the difference
from other portraits, so that once all are viewed together, it allows to identify the particular version. The directory
names are used verbatim by module code when providing the user with a list of options to choose from. The default portraits
(residing next to the 'alternatives' directory) should be present among other subdirectories again. Each alternative 
directory should contain the exact same set of files (in terms of their name, not contents naturally). The best practice here is having the default portraits be ref files pointing to one of the alternative directories.



3. CHARNAME directory structure.

The files for CHARNAME are likewise grouped in a 4-deep directory tree, but the functions of the levels are different:

	src/charname/<set>/<gender>/<function>

where:
  - set:	name of the individual portrait group presented during installation. Each set might be installed
          	(or ommitted) separately.

  - gender:	male/female. Used by module code to provide the appropriate group during character creation based on
          	selected gender of the PC.

  - function:	groups files based on their presence in the game and handling by the module code. These are:
                  - override:	replacements for portrait files already present in the game.
        	  - unique:	new, additional files not existing in the game.
         	  - pool:	special directory to which some of the NPC portraits might be copied based on chosen
         	         	installation options.



4. File name format.

Replacements for existing files are named after the replaced files. All new files start with a 'BF' module prefix,
followed by (up to) 5 characters and a letter determining the portrait size (resolution). Reccuring resolutions are:

  - L: 210x330
  - M: 169x266
  - N: 140x220
  - O: 126x198
  - P: 110x173
  - Q: 90x140
  - S: 54x84
Of these, only 'L', 'M' and 'S' are handled specially: 'L' becomes the 'large' portrait for a character, and 'M' the
'small' portrait. In case the latter is missing, 'S' is used instead. All other options have no in-game function and
serve only an informational purpose. Portraits for PC come only in the 'L' size as Enhanced Editions resize 
the portraits themselves and there is no option to provide separate files in an unmodified game. A set of portraits
for a joinable NPC should contain a 'L' and 'M' (or 'L' and 'S') files; all other NPCs will generally receive a single
portrait, which resolution will depend on the resolution of the original image. The size letter is ignored in that case
(although might be used in the future, if new functionality is implemented).

Portraits for humanoid characters (in particular those for the playable characters) follow the scheme of:

<prefix><gender><race><class><id><size>.<extension>

where:
  - <prefix>:	module identifier 'BF' serving to limit the chance of name conflicts.

  - <gender>:   [M|F|B|G|O] for Male/Female/Boy/Girl/Other (first two only for CHARNAME portraits).

  - <race>:	[D|E|G|H|M|O|R|T] for Dwarf/Elf(and half-elf)/Gnome/Halfling/huMan/half-Orc/dRow/Tiefling 
          	(the latter being non-playable).

  - <class>:	[A|B|C|D|F|K|M|N|P|R|T|W] for 
         	Any/Bard/Cleric/Druid/Fighter(light armour)/Knight(plate)/Monk/Noble/Peasant/Ranger/Thief/Wizard.
           	Noble and Peasant are special classes reserved for game characters, not available to the player.

  - <id>:	usually a two-digit number identifying the file. Unique only among files with the same prefix
         	(i.e, gender, race and class). Different portrait sets may have ids from different ranges
         	and, in case the needs exceed the decimal range, latin letters may be used instead.

  - <size>:	single letter specifying the resolution of the image and, for 'L', 'M' and 'S', its function.

  - <extension>:file format. Must be 'bmp' or one of the special reference files (see the next section).

Apart from the portrait size and the fixed prefix, the file name is not interpreted currently by module code and
serves primarily to organise and sort the files for humans. The sorting of CHARNAME files determines the order
in which they are presented in the character generation screen. With this in mind, the scheme was designed so as
it group most like portraits close to each other (pictured 'class' is more arbitrary than 'race', halflings are
closer in looks to Humans than Drow, various fighters are grouped close to each other, etc.).

Where the format does not apply - for example for demons and dragons - the middle portion of the file name will
instead reflect the creature type, if possible. 



5. File types.

Apart from module code residing outside the listed top-level directories, all files must have one of the following
extension, depending on their contents and format:

 - .bmp:	self explanatory, image files to be used by the game.

 - .2da:	list of game creatures receiving a given portrait file. The file must reside next to portrait files in
        	in a directory on the 'npc' level, and its base name must be the same as that of one of one of the adjacent
        	portrait files. Each line should contain a creature code (creature file name to patch). If the portrait
       		file name (and base name of this file) ends with 'S', it is used as the small portrait for the creature
        	and, if either a matching 'M' or 'L' (in that search order) file is also found, it is used for the large
          	portrait. Similarly, if the file name ends with 'M', and an 'L' file exists in the same directory, 
       		the former is used for the small portrait and the latter for the large portrait. Otherwise the matching
     		portrait file is used as both the large and small portraits.

 - .ref:	a 'symbolic link' to a single portrait file and recognised by the module. It must contain a single line
        	containing a path to a portrait file, relative to the top-level module directory (src in the repository). 
        	It might or might not contain the file extension, but must point to either a 'bmp' or another 'ref' file.
       		When encountered, the target file is copied instead of the reference, but the name of the reference is 
        	used as the final portrait name rather than that of the copied file. This feature is used to avoid having
        	several copies of a single file, or to rename a file, depending on the context of use.

 - .refs:	similar to '.ref', it contains a list of portraits to be copied in place of the 'refs' file. Each line
        	denotes a single file and should contain two columns, separated by a 'tab' character. The first is the
         	final name of the file after copying, without an extension. The second must be the path to the copied file, 
         	as in a '.ref' file.

