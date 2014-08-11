#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

# fsyringe (File Syringe) inject or extract data from file.
# author: Fernando Iazeolla
# licence: GPLv2
# web : http://github.com/elboza/fsyringe

package fsyringe;
    $fsyringe::VERSION="0.1";
    $fsyringe::VERBOSE=0;
    $fsyringe::BUFFSIZE=255;
package main;
sub show_version{
    print "fsyringe v$fsyringe::VERSION ";
}

sub show_usage{
    show_version;
    print <<EOF;
by Fernando Iazeolla 2013.
File Syringe (fsyringe) ... inject or extract data from a file.
This software is distributed under GPLv2 licence.

USAGE:
fsyringe [OPTIONS] FILE
fsr [OPTIONS] FILE

OPTIONS:
--help      -h          show this help
--help fmt  -h fmt      show fmt options
--version   -v          show program version
--extract   -e 'fmt'    extract from file (see perldoc -f pack)
--inject    -i 'fmt'    inject into file (see perldoc -f pack)
--offset    -o n        offset from beginning of file(hex(0x) or dec)
--print     -p          stdout format
--data      -d 'xxx'    data to inject
--verbose   -vv         verbose output
--file      -f 'file'   file

* FILE can be specified as ARGV or as a parameter -f (your choice :) )
* extract and inject format (fmt) are explained in 'perldoc -f pack'
  or in fsyringe's man page or type 'fsyringe --help fmt'.
* inject will overwrite data.

EXAMPLES:
* fsyrynge -o 3 -e 'S' -f filename #will extract an unsigned short value (16bit) from offset 3 of filename file.
* fsyrynge -o 4 -i 'a2' -d 'foo' filename #will inject at offset 4 of filename the string 'fo'.

EOF
    
    exit(1);
}
sub show_fmt{
	print <<EOF;
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
   (Quads are available only if your system supports 64-bit integer values _and_ if Perl has been compiled to support those.  Raises an exception otherwise.)
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
U  A Unicode character number.  Encodes to a character in character mode and UTF-8 (or UTF-EBCDIC in EBCDIC platforms) in byte mode.
w  A BER compressed integer (not an ASN.1 BER, see perlpacktut for details).  Its bytes represent an unsigned integer in base 128, most significant digit first, with as few digits as possible.  Bit eight (the high bit) is set on each byte except the last.
x  A null byte (a.k.a ASCII NUL, "\000", chr(0))
    
>   sSiIlLqQ   Force big-endian byte-order on the type.
                jJfFdDpP   (The "big end" touches the construct.)
<   sSiIlLqQ   Force little-endian byte-order on the type.
                jJfFdDpP   (The "little end" touches the construct.)	
EOF
    exit(1);
}

sub m_die{
    print @_;
    exit(1);
}

sub m_warn{
    print @_;
}

sub p_verbose{
    print @_ if($fsyringe::VERBOSE);
}

sub opt_version_handler{
    show_version;
    print "\n";
    exit(1);
}

sub opt_help_handler{
	my ($opt_name,$opt_value)=@_;
	if($opt_value eq "fmt")
	{
		show_fmt;
	}
	else
	{
		show_usage;
	}
}

sub get_int{
    my $offs=shift @_;
    return $offs+0 if($offs=~/^\d+$/);
    return hex $offs if($offs=~/^(0x)?[\da-f]+$/i);
    m_die("!error. offset is not a (dec or hex) number.\n");
}

sub inject{
    my ($data,$inject,$offset,$fd)=@_;
    seek $fd,$offset,0;
    my $x=pack $inject,split / /,$data;
    print $fd $x;
}

sub extract{
    my ($extract,$offset,$fd)=@_;
    seek $fd,$offset,0;
    read $fd,my $buff,$fsyringe::BUFFSIZE;
    my @x=unpack $extract,$buff;
    print "@x\n";
}

sub main{
    my ($file,$inject,$extract,$data,$offset,$print,$offs)=(undef,undef,undef,undef,undef,undef,0);
    GetOptions('help|h:s' => \&opt_help_handler,
    'version|v' => \&opt_version_handler,
    'extract|e=s' => \$extract,
    'verbose|vv' => \$fsyringe::VERBOSE,
    'inject|i=s' => \$inject,
    'data|d=s'=>\$data,
    'offset|o=s'=>\$offset,
    'print|p=s'=>\$print,
    'file|f=s'=> \$file
    ) or die "Error in command line argument. Try 'fsyringe --help' .";
    #m_die "!ERROR. missing file.\ntry 'fsyringe --help' .\n" if($#ARGV);
    m_die "!action error. (extract or inject?!?)\n" if($inject && $extract);
    if(!$file){
        m_die "!ERROR. missing file.\ntry 'fsyringe --help' .\n" if($#ARGV);
        $file=shift @ARGV;
    }
    if(!$offset){
        $offs=0;
    }
    else{
        $offs=get_int $offset;
    }
    printf("data: %s\noffset: %d\nprint:%s\n",$data,$offs,$print) if($fsyringe::VERBOSE);
    if($inject){
        open(my $fd,"+<",$file)or m_die "!error opening file.\n" ;
        if($fd){
            inject($data,$inject,$offs,$fd);
            close $fd;
        }
    }elsif($extract){
        open (my $fd,"<",$file) or m_die "!error opening file.\n" ;
        if($fd){
            extract($extract,$offs,$fd);
            close $fd;
        }
    }else{
        print "!missing action. (extract or inject?!?)\n";
    }

}

main
