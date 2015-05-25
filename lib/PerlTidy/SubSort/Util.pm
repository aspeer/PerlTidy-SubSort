#
#  This file is part of PerlTidy::SubSort.
#
#  This software is copyright (c) 2015 by Andrew Speer <andrew.speer@isolutions.com.au>.
#
#  This is free software; you can redistribute it and/or modify it under
#  the same terms as the Perl 5 programming language system itself.
#
#  Full license text is available at:
#
#  <http://dev.perl.org/licenses/>
#
package PerlTidy::SubSort::Util;


#  Pragma
#
use strict;
use vars qw($VERSION @EXPORT);
use warnings;
no warnings qw(uninitialized);


#  External modules
#
use Carp;


#  Export functions
#
use base 'Exporter';
@EXPORT=qw(err msg arg debug);


#  Version information in a format suitable for CPAN etc. Must be
#  all on one line
#
$VERSION='0.015';


#  Done
#
1;

#==================================================================================================


sub debug {


    #  Debug
    #
    goto &msg if $ENV{PERLTIDY_SUBSORT_DEBUG}

}


sub err {


    #  Quit on errors
    #
    my $msg=shift();
    croak &fmt("*error*\n\n" . ucfirst($msg), @_);

}


sub fmt {


    #  Format message nicely. Always called by err or msg so caller=2
    #
    my $message=sprintf(shift(), @_);
    chomp($message);
    my $caller=(split(/:/, (caller(2))[3]))[-1];
    $caller=~s/^_?!(_)//;
    my $format=' @<<<<<<<<<<<<<<<<<<<<<< @<';
    formline $format, $caller . ':', '';
    $message=$^A . $message; $^A=undef;
    return $message;

}


sub msg {


    #  Print message
    #
    CORE::print &fmt(@_), "\n";

}
