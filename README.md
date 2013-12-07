fsyringe
========
**file syringe

```

fsyringe v0.1 by Fernando Iazeolla 2013.
File Syringe (fsyringe) ... inject or extract data from a file.

USAGE:
fsyringe [OPTIONS] FILE

OPTIONS:
--help      -h          show this help
--version   -v          show program version
--extract   -e 'fmt'    extract from file (see perldoc -f pack)
--inject    -i 'fmt'    inject into file (see perldoc -f pack)
--offset    -o n        offset from beginning of file
--print     -p          stdout format
--data      -d 'xxx'    data to inject
--verbose   -vv         verbose output
--file      -f 'file'   file

* FILE can be specified as ARGV or as a parameter -f (your choice :) )
* extract and inject format (fmt) are explained in 'perldoc -f pack'.
* inject will overwrite data.

EXAMPLES:
* fsyrynge -o 3 -e 'S' -f filename #will extract an unsigned short value (16bit) from offset 3 of filename file.
* fsyrynge -o 4 -i 'a2' -d 'foo' filename #will inject at offset 4 of filename the string 'fo'.

```
