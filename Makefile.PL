use 5.006;
use ExtUtils::MakeMaker;
my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) { # dev version
    $mm_ver = eval $mm_ver;
    die $@ if $@;
}
my %WriteMakefile=(
    NAME                => 'PerlTidy::SubSort',
    VERSION_FROM        => $::version_from_fn='lib/PerlTidy/SubSort.pm',
    ABSTRACT_FROM       => $::version_from_fn,
    EXE_FILES           => ['bin/perltidy_subsort'],
    LICENSE             => 'perl_5',
    AUTHOR              => 'Andrew Speer <andrew.speer@isolutions.com.au>',
    MIN_PERL_VERSION	=> '5.006',
    META_MERGE => { 
        'meta-spec'         => {
            version         => 2
        },
        resources           => {
            homepage        => 'https://github.com/aspeer/PerlTidy-SubSort',
            repository      => {
                type        => 'git',
                url         => 'https://github.com/aspeer/PerlTidy-SubSort.git',
                web         => 'https://github.com/aspeer/PerlTidy-SubSort'
            }
        }
    },
    'depend'                            =>  {
        Makefile                        =>  '$(VERSION_FROM)',
    },
);
my %MM_Compat=(
    '6.31'              => [q(LICENSE)],
    '6.46'              => [q(META_MERGE)],
    '6.48'              => [q(MIN_PERL_VERSION)],
    '6.52'              => [q(CONFIGURE_REQUIRES)],
    '6.5503'            => [q(BUILD_REQUIRES)],
    '6.64'              => [q(TEST_REQUIRES)],
);
while (my($mm_ver_test, $ar)=each %MM_Compat) {
    if (version->parse($mm_ver) < version->parse($mm_ver_test)) {
        delete @WriteMakeFile{@{$ar}};
        print 'delete'.Dumper($ar);
    }
}
WriteMakefile(%WriteMakefile);
package MY;
sub post_initialize {
    #  Add license file, other support files here
    #
    my $mm_or=shift();
    $mm_or->{'PM'}{'LICENSE'}='$(INST_LIBDIR)/$(BASEEXT)/LICENSE';
    $mm_or->SUPER::post_initialize;
};
