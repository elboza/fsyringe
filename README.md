fsyringe
========
####File Syringe (fsyringe) ... inject or extract data from a file.

**file syringe

## help

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

## format templates

for a complete reference see ``` perldoc -f pack ```

```
 a  A string with arbitrary binary data, will be null padded.
    A  A text (ASCII) string, will be space padded.
    Z  A null-terminated (ASCIZ) string, will be null padded.
    b  A bit string (ascending bit order inside each byte,
       like vec()).
    B  A bit string (descending bit order inside each byte).
    h  A hex string (low nybble first).
    H  A hex string (high nybble first).
    c  A signed char (8-bit) value.
    C  An unsigned char (octet) value.
    W  An unsigned char value (can be greater than 255).
    s  A signed short (16-bit) value.
        S  An unsigned short value.
        l  A signed long (32-bit) value.
    L  An unsigned long value.
    q  A signed quad (64-bit) value.
        Q  An unsigned quad value.
         (Quads are available only if your system supports 64-bit
          integer values _and_ if Perl has been compiled to support
          those.  Raises an exception otherwise.)
    i  A signed integer value.
    I  A unsigned integer value.
         (This 'integer' is _at_least_ 32 bits wide.  Its exact
          size depends on what a local C compiler calls 'int'.)
    n  An unsigned short (16-bit) in "network" (big-endian) order.
    N  An unsigned long (32-bit) in "network" (big-endian) order.
    v  An unsigned short (16-bit) in "VAX" (little-endian) order.
    V  An unsigned long (32-bit) in "VAX" (little-endian) order.
    j  A Perl internal signed integer value (IV).
    J  A Perl internal unsigned integer value (UV).
    f  A single-precision float in native format.
    d  A double-precision float in native format.
    F  A Perl internal floating-point value (NV) in native format
    D  A float of long-double precision in native format.
         (Long doubles are available only if your system supports
          long double values _and_ if Perl has been compiled to
          support those.  Raises an exception otherwise.)
    p  A pointer to a null-terminated string.
    P  A pointer to a structure (fixed-length string).
    u  A uuencoded string.
    U  A Unicode character number.  Encodes to a character in char-
       acter mode and UTF-8 (or UTF-EBCDIC in EBCDIC platforms) in
       byte mode.
    w  A BER compressed integer (not an ASN.1 BER, see perlpacktut
       for details).  Its bytes represent an unsigned integer in
       base 128, most significant digit first, with as few digits
       as possible.  Bit eight (the high bit) is set on each byte
       except the last.
    x  A null byte (a.k.a ASCII NUL, "\000", chr(0))
    
    >   sSiIlLqQ   Force big-endian byte-order on the type.
                jJfFdDpP   (The "big end" touches the construct.)
    <   sSiIlLqQ   Force little-endian byte-order on the type.
                jJfFdDpP   (The "little end" touches the construct.)
```
           