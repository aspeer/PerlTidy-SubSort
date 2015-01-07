#!/usr/bin/env perl

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


#  Package to sort subroutines within a perl file
#
package PerlTidy::SubSort;


#  Pragma
#
use strict;
use vars qw($VERSION @EXPORT_OK);
use warnings;


#  Export functions
#
use base 'Exporter';
@EXPORT_OK=qw(subsort);


#  External Modules
#
use PPI;
use PerlTidy::SubSort::Util;


#  Version
#
$VERSION='0.015';


#  Done
#
1;


#==================================================================================================


sub subsort {


    #  Get document file name as argument
    #
    my $ppi_fn=shift() ||
        return err ('no filename supplied');
    my $ppi_or=PPI::Document->new($ppi_fn) ||
        return err ("can't open $ppi_fn, $!");


    #  Hoover up subroutines into an array by order and hash by name
    #
    my (%sub_public,  @sub_public);
    my (%sub_private, @sub_private);
    SUB: foreach my $sub (@{$ppi_or->find('PPI::Statement::Sub') || []}) {

        #  Ignore BEGIN etc.
        next if (ref($sub) eq 'PPI::Statement::Scheduled');

        #  Ignore subs with # no subsort pragra
        foreach my $comment (@{$sub->find('PPI::Token::Comment') || []}) {
            next SUB if ($comment->content)=~/no\s+subsort/
        }
        unless ($sub->forward) {
            if ((my $sub_name=$sub->name)=~/^_/) {
                push @sub_private, $sub;
                $sub_private{$sub_name}=$sub;
            }
            else {
                push @sub_public, $sub;
                $sub_public{$sub_name}=$sub;
            }
        }
    }


    #  Now sort by alpha name for public routines
    #
    my @sub_public_sort;
    foreach my $sub_name (sort {$a cmp $b} keys %sub_public) {
        push @sub_public_sort, $sub_public{$sub_name}->clone();
    }
    foreach my $i (0..$#sub_public_sort) {
        my ($sub_remove, $sub_insert)=($sub_public[$i], $sub_public_sort[$i]);
        $sub_remove->insert_before($sub_insert);
        $sub_remove->delete();

    }


    #  Now sort by alpha name for private
    #
    my @sub_private_sort;
    foreach my $sub_name (sort {$a cmp $b} keys %sub_private) {
        push @sub_private_sort, $sub_private{$sub_name}->clone();
    }
    foreach my $i (0..$#sub_private_sort) {
        my ($sub_remove, $sub_insert)=($sub_private[$i], $sub_private_sort[$i]);
        $sub_remove->insert_before($sub_insert);
        $sub_remove->delete();

    }


    #  All done - save
    #
    $ppi_or->save($ppi_fn);


    #  Return number of routines sorted
    #
    my $count=@sub_public+@sub_private;
    return \$count;

}

__END__

=head1 Name

PerlTidy::SubSort -- sort subroutines in your Perl files (.pl, .pm etc.) into alphabetical order


=head1 Synopsis

C<<< perltidy_subsort <filename> >>>


=head1 Overview

This module and associated script utility will sort subroutines in your Perl files (.pl, .pm etc.) into alphabetical order.


=head1 Installation

As per standard Perl installation procedure

    perl Makefile.PL
    make
    make test
    make install



=head1 Dependencies

This module requires the following CPAN modules:

=over

=item -

PPI


=back


=head1 Usage

    #  From command line
    perltidy_subsort foo.pm
    
    #  In Perl code
    use PerlTidy::SubSort;
    my $count_sr=PerlTidy::SubSort->subsort('foo.pm');
    print "sorted ${$count_sr} subroutines\n";


The following methods are supplied by the module:

subsort(filename)

Supply a file name for sorting. The file will be edited in place (no backup will be made). The method will return a scalar reference to the number of subroutines sorted.


=head1 Notes

Subroutines starting with an underscore character (e.g. sub _foo {}) are considered private. They are still sorted - but put after non-private subroutines.

If you do not wish a subroutine sorted (moved) place the  # no
     subsort pragma anywhere in the subroutine code block to preserve the current location order: E.g.

    sub foo { # no subsort
        my $foo=1
    }



=head1 License

This software is copyright (c) 2014 by Andrew Speer <>.

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.

Full license text is available at:

<L<http://dev.perl.org/licenses/>>
