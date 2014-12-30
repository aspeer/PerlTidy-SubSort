use 5.010001;
use ExtUtils::MakeMaker;
my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) { # dev version
    $mm_ver = eval $mm_ver;
    die $@ if $@;
    die "need ExtUtils::MakeMaker 6.31 or higher" if ($mm_ver < 6.31);
}
WriteMakefile(
    NAME        => 'Local::Script::perltidy_subsort',
    EXE_FILES   => ['bin/perltidy_subsort.pl'],
    MAN3PODS    => {},
    LICENSE     => 'perl_5',
    AUTHOR      => 'Andrew Speer <andrew.speer@isolutions.com.au>'
);
