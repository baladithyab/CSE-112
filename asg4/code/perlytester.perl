#!/usr/bin/perl
# $Id: subst-macros.perl,v 1.10 2021-06-01 19:23:40-07 - - $

# Example substituting macros in a command.

use Data::Dumper;
use strict;
use warnings;

$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
sub dump_hash ($\%) {
   my ($label, $hashptr) = @_;
   print STDERR "%$label: ", Data::Dumper->Dump ([$hashptr]);
}

my %MACROS = (
  'CHECKIN' => {
    'LINE' => 7,
    'VALUE' => '${MKFILE} ${SOURCES} ${HEADERS}'
  },
  'EXECBIN' => {
    'LINE' => 8,
    'VALUE' => 'hello'
  },
  'HEADERS' => {
    'LINE' => 5,
    'VALUE' => 'hello.h'
  },
  'MKFILE' => {
    'LINE' => 3,
    'VALUE' => 'Makefile'
  },
  'OBJECTS' => {
    'LINE' => 6,
    'VALUE' => 'main.o hello.o'
  },
  'SOURCES' => {
    'LINE' => 4,
    'VALUE' => 'main.c hello.c'
  }
);
my %GRAPH = (
  '${EXECBIN}' => {
    'COMMANDS' => [
      {
        'CMD' => 'gcc -g ${OBJECTS} -o ${EXECBIN}',
        'LINE' => 13
      }
    ],
    'LINE' => 12,
    'PREREQS' => [
      '${OBJECTS}'
    ]
  },
  '%.o' => {
    'COMMANDS' => [
      {
        'CMD' => 'gcc -g -c $<',
        'LINE' => 16
      }
    ],
    'LINE' => 15,
    'PREREQS' => [
      '%.c'
    ]
  },
  'all' => {
    'LINE' => 10,
    'PREREQS' => [
      '${EXECBIN}'
    ]
  },
  'clean' => {
    'COMMANDS' => [
      {
        'CMD' => '- rm ${OBJECTS} ${EXECBIN}',
        'LINE' => 22
      }
    ],
    'LINE' => 21,
    'PREREQS' => []
  },
  'hello.o' => {
    'LINE' => 24,
    'PREREQS' => [
      'hello.c',
      'hello.h'
    ]
  },
  'main.o' => {
    'LINE' => 25,
    'PREREQS' => [
      'main.c',
      'hello.h'
    ]
  },
  'test' => {
    'COMMANDS' => [
      {
        'CMD' => './${EXECBIN} ; echo status = $$?',
        'LINE' => 19
      }
    ],
    'LINE' => 18,
    'PREREQS' => [
      '${EXECBIN}'
    ]
  }
);

my $prereq = "hello.c";
my @commands = (
   'echo /${ABC}/${FOOBAR}/${THING}/',
   'gcc -c $<',
   'echo $$?',
);

# for my $command (@commands) {
#    print "Before: $command\n";
#    $command =~ s/\$\{(.*?)\}/$MACROS{$1}{VALUE}||""/ge;
#    $command =~ s/\$</$prereq/;
#    $command =~ s/\$\$/\$/;
#    print "After: $command\n";
# }

# print keys %GRAPH;
# print "\n";

# Recursive sub macro vals for other macro vals
sub mac_sub_helper($);
sub mac_sub_helper($){
    my ($v) = @_;
    ($v) = ($v =~ /\$\{(.*)\}/);
    my $val = $MACROS{$v}{VALUE};
    my @vals = split ' ', $val;
    my $new_vals='';
    foreach my $v (@vals){
        if($v =~ m/(?<=\$\{)(.*)(?=\})/){
            print "$v is macro...\n";
            $new_vals = $new_vals . " " . mac_sub_helper($v);
        }else{
            $new_vals = $new_vals . " " . $v;
        }
    }
    $MACROS{$v}{VALUE} = $new_vals;
}

sub mac_sub{
    # sub macro vals for other macro vals
    my @macs = keys %MACROS;
    for (@macs){
        my $val = $MACROS{$_}{VALUE};
        my @vals = split ' ', $val;
        my $new_vals='';
        foreach my $v (@vals){
            if($v =~ m/(?<=\$\{)(.*)(?=\})/){
                $new_vals = $new_vals . " " . mac_sub_helper($v);
            }else{
                $new_vals = $new_vals . " " . $v;
            }
        }
        $new_vals =~ s/^\s+//;
        $MACROS{$_}{VALUE} = $new_vals;        
    }
    # print Dumper(%MACROS);

    # copy wildcard cmd to other targets
    my @targets = keys %GRAPH;
    for (@targets){
        if ($_ =~ m/\%.+/){
            my $tempCMD = $GRAPH{$_}{'COMMANDS'}[0]{'CMD'};
            my $tempLINE = $GRAPH{$_}{'COMMANDS'}[0]{'LINE'};
            for (@targets){
                if($_ =~ m/\.o$/ && not($_ =~ m/\%.+/)){
                    $GRAPH{$_}{'COMMANDS'}[0]{'CMD'} = $tempCMD;
                    $GRAPH{$_}{'COMMANDS'}[0]{'LINE'} = $tempLINE;
                }
            }
        }
    }
    # sub prereqs for respective macro vals
    @targets = keys %GRAPH;
    for (@targets){
        if (defined ($GRAPH{$_}{'PREREQS'})){
            my @PRQ_new;
            for my $prq (@{$GRAPH{$_}{'PREREQS'}}){
                $prq =~ s/\$\{(.*?)\}/$MACROS{$1}{VALUE}||""/ge;
                my @prq_split = (split ' ',$prq);
                push @PRQ_new, @prq_split;
            }
            # print join(' | ',@PRQ_new);
            # print "\n";
            my $idx =0;
            for my $prq (@PRQ_new){
                $GRAPH{$_}{'PREREQS'}[$idx] = $prq;
                $idx+=1;
            }
            
        }
    }

    # sub cmds for respective macro vals
    @targets = keys %GRAPH;
    for (@targets){
        if (defined ($GRAPH{$_}{'COMMANDS'}[0]{'CMD'})){
            my $cmd = $GRAPH{$_}{'COMMANDS'}[0]{'CMD'};
            $cmd =~ s/\$\{(.*?)\}/$MACROS{$1}{VALUE}||""/ge;
            $cmd =~ s/\$</$GRAPH{$_}{'PREREQS'}[0]/;
            $cmd =~ s/\$\$/\$/;
            $GRAPH{$_}{'COMMANDS'}[0]{'CMD'} = $cmd;
        }
    }

    # sub targets for respective macro vals
    @targets = keys %GRAPH;
    for (@targets){
        if($_ =~ m/(?<=\$\{)(.*)(?=\})/){
            my $temp1 = $GRAPH{$_};
            delete $GRAPH{$_};
            $_ =~ s/\$\{(.*?)\}/$MACROS{$1}{VALUE}||""/ge;
            $GRAPH{$_} = $temp1;
        }
        # elsif ($_ =~ m/\%.+/){
        #     my $tempCMD = $GRAPH{$_}{'COMMANDS'}[0]{'CMD'};
        #     my $tempLINE = $GRAPH{$_}{'COMMANDS'}[0]{'LINE'};
        #     for (@targets){
        #         if($_ =~ m/\.o$/ && not($_ =~ m/\%.+/)){
        #             $GRAPH{$_}{'COMMANDS'}[0]{'CMD'} = $tempCMD;
        #             $GRAPH{$_}{'COMMANDS'}[0]{'LINE'} = $tempLINE;
        #         }
        #     }
        # }
    }
    print Dumper(%GRAPH);
}

mac_sub;