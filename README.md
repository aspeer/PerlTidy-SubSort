Name
====

PerlTidy::SubSort -- sort subroutines in your Perl files (.pl, .pm etc.) into alphabetical order

Synopsis
========

`perltidy_subsort <filename>`

Overview
========

This module and associated script utility will sort subroutines in your Perl files (.pl, .pm etc.) into alphabetical order.

Installation
============

As per standard Perl installation procedure

    perl Makefile.PL
    make
    make test
    make install

Dependencies
============

This module requires the following CPAN modules:

-   PPI

Usage
=====

    #  From command line
    perltidy_subsort foo.pm

    #  In Perl code
    use PerlTidy::SubSort;
    my $count_sr=PerlTidy::SubSort->subsort('foo.pm');
    print "sorted ${$count_sr} subroutines\n";

The following methods are supplied by the module:

subsort(filename)  
Supply a file name for sorting. The file will be edited in place (no backup will be made). The method will return a scalar reference to the number of subroutines sorted.

Notes
=====

Subroutines starting with an underscore character (e.g. sub \_foo {}) are considered private. They are still sorted - but put after non-private subroutines.

If you do not wish a subroutine sorted (moved) place the `# no
    subsort` pragma anywhere in the subroutine code block to preserve the current location order: E.g.

    sub foo { # no subsort
        my $foo=1
    }

License
=======

This software is copyright (c) 2014 by Andrew Speer \<<andrew.speer@isolutions.com.au>\>.

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.

Full license text is available at:

\<<http://dev.perl.org/licenses/>\>
