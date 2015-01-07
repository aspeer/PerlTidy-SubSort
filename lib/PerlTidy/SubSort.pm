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
$VERSION='0.007';


#  Done
#
1;


#==================================================================================================


sub subsort {


    #  Get document file name as argument
    #
    my $ppi_fn=shift() ||
        return err('no filename supplied');
    my $ppi_or = PPI::Document->new($ppi_fn) ||
        return err("can't open $ppi_fn, $!");


    #  Hoover up subroutines into an array by order and hash by name
    #
    my (%sub_public, @sub_public);
    my (%sub_private, @sub_private);
    SUB: foreach my $sub ( @{ $ppi_or->find('PPI::Statement::Sub') || [] } ) {
        #  Ignore BEGIN etc.
        next if (ref($sub) eq 'PPI::Statement::Scheduled');
        #  Ignore subs with # no subsort pragra
        foreach my $comment ( @{ $sub->find('PPI::Token::Comment') || [] } ) {
            next SUB if ($comment->content)=~/no\s+subsort/
        }
        unless ( $sub->forward ) {
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
    my $count=@sub_public + @sub_private;
    return \$count;

}

__END__

=head LICENSE

This software is copyright (c) 2014 by Andrew Speer <andrew.speer@isolutions.com.au>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Full license text is available at:

<http://dev.perl.org/licenses/>
