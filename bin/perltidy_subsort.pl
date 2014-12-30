#!/usr/bin/env perl

#  This file is part of Local::Script::perltidy_subsort.
#
#  This software is copyright (c) 2014 by Andrew Speer <andrew.speer@isolutions.com.au>.
#
#  This is free software; you can redistribute it and/or modify it under
#  the same terms as the Perl 5 programming language system itself.
#
#  Full license text is available at:
#
#  <http://dev.perl.org/licenses/>
#
use strict;
use warnings;
use PPI;
use PPI::Dumper;
use Data::Dumper;


#  Set version
#
$::VERSION='0.003';


#  Get root document from command line
#
my $ppi_fn=$ARGV[0] || die "usage: $0 filename";
my $ppi_or = PPI::Document->new($ppi_fn) or die "oops";


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

$ppi_or->save($ppi_fn);

__END__

=head LICENSE

This software is copyright (c) 2014 by Andrew Speer <andrew.speer@isolutions.com.au>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Full license text is available at:

<http://dev.perl.org/licenses/>
