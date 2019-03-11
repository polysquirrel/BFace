This is a special directory for portraits for PCs named after portrait files presented 
during character generation. It is automatically filled with files from the 'charname/override' 
directory tree during installation. Based on user's selection of options, files used to actually
override in-game portraits are removed from the pool, so that only unused (not installed) portraits 
remain. Files here are referenced by 'symlinks' from the adjacent standard game directories;
this way every file from the pool/override can be referenced by a .ref file following the portrait
naming pattern shared by all pc-only portraits. Removing files from this pool will invalidate
those refereces, but those with legal targets remaining will result in creating files named after 
the reference and not 'override' name of the actual pooled portrait.
