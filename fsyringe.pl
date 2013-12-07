#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

# fsyringe
# by Fernando Iazeolla
# licence: GLPv2

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
    show_usage;
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
    my ($file,$inject,$extract,$data,$offset,$print)=(undef,undef,undef,undef,0,undef);
    GetOptions('help|h' => \&opt_help_handler,
    'version|v' => \&opt_version_handler,
    'extract|e=s' => \$extract,
    'verbose|vv' => \$fsyringe::VERBOSE,
    'inject|i=s' => \$inject,
    'data|d=s'=>\$data,
    'offset|o=i'=>\$offset,
    'print|p=s'=>\$print,
    'file|f=s'=> \$file
    ) or die "Error in command line argument. Try 'fsyringe --help' .";
    #m_die "!ERROR. missing file.\ntry 'fsyringe --help' .\n" if($#ARGV);
    m_die "!action error. (extract or inject?!?)\n" if($inject && $extract);
    if(!$file){
        m_die "!ERROR. missing file.\ntry 'fsyringe --help' .\n" if($#ARGV);
        $file=shift @ARGV;
    }
    printf("data: %s\noffset: %d\nprint:%s\n",$data,$offset,$print) if($fsyringe::VERBOSE);
    if($inject){
        open(my $fd,"+<",$file)or m_die "!error opening file.\n" ;
        if($fd){
            inject($data,$inject,$offset,$fd);
            close $fd;
        }
    }elsif($extract){
        open (my $fd,"<",$file) or m_die "!error opening file.\n" ;
        if($fd){
            extract($extract,$offset,$fd);
            close $fd;
        }
    }else{
        print "!missing action. (extract or inject?!?)\n";
    }

}

main
