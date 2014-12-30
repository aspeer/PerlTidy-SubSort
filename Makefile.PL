use 5.010001;
use ExtUtils::MakeMaker;
my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) { # dev version
    $mm_ver = eval $mm_ver;
    die $@ if $@;
    die "need ExtUtils::MakeMaker 6.48 or higher" if ($mm_ver < 6.48);
}
WriteMakefile(
    NAME                => 'Local::Script::perltidy_subsort',
    EXE_FILES           => [$::exe_fn='bin/perltidy_subsort.pl'],
    VERSION_FROM        => $::exe_fn,
    MAN3PODS            => {},
    LICENSE             => 'perl_5',
    AUTHOR              => 'Andrew Speer <andrew.speer@isolutions.com.au>',
    MIN_PERL_VERSION	=> '5.006',
);

package MY;
sub post_initialize {

    #  Add license file, other support files here
    #
    my $mm_or=shift();
    $mm_or->{'PM'}{'LICENSE'}='$(INST_LIBDIR)/$(BASEEXT)/LICENSE';
    $mm_or->SUPER::post_initialize;

};
