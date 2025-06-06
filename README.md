# CPANSec Patch Tooling POC
1. Patches distributed in seperate distribution [patches](CPANSec-Patches/lib/patches/)
2. Use (existent) patch tooling [CPAN::Patches](https://metacpan.org/pod/CPAN::Patches) from CPAN
3. Opt in apply in cpm (`--with-security-fixes`) - [patch applied after fetch](https://github.com/thibaultduponchelle/cpansec-patch-tooling-poc/blob/main/cpm/lib/App/cpm/Worker/Installer.pm#L216-L225)

Notes:
- Non-POC version should use [CPAN::Distroprefs](https://metacpan.org/pod/CPAN::Distroprefs) (not implemented)
- Should be optional requirements in cpm (not implemented)
- An example of patch - [CPANSec-Patches/lib/patches/acme-lsd/patches](CPANSec-Patches/lib/patches/acme-lsd/patches)
- Patches should remain compatible out of CPAN installers (for distribution packagers to apply with their own tooling)

## CPAN::Distroprefs
- distroprefs/
  - pref.yml 
- patches/
  - patch.patch (referenced by pref) 

Characteristics:
- In core
- More flexibility (can match version or not)
- ~~Need to configure CPAN.pm~~
- Not managing paching

## CPAN::Patches
- patches/
  - acme-module/
    - patches/
      - patch.patches
      - series (list patches to apply)

Characteristics:
- Not in core
- Match module (no version)



## Schema
![CPANSec patch tooling POC](cpansec-patch-tooling-poc.png)

## Resources
- [Fixing a Perl module during CI workflow](https://briandfoy.github.io/fixing-a-perl-module-in-the-middle-of-a-github-workflow/)
- [Tuto CPAN::Distroprefs](https://briandfoy.github.io/a-cpan-distroprefs-example/)

## Principles
- Patches are distributed separately in one or multiple "database" module(s) (ala CPANSA-DB)
- Patches compatibles in particular for usage out of CPAN installers (e.g. tooling from Linux distributions packagers) and between CPAN::Distroprefs and CPAN::Patches
- Apply patches in CPAN installers is opt-in "--with-security-patches"
- Technically, patching module and database module should remain an optional requirement in CPAN installers
- Possible auto-update of database module
- Code added to CPAN Installer remains as minimal as possible

## Ideas
0. Wrap CPAN::Distroprefs into an intermediate tooling to add patching facilities
1. Move CPAN::Distroprefs patching from Distribution.pm to Distroprefs, then use CPAN::Distroprefs (directly or not) from CPAN Installers
2. Add CPAN::Distroprefs as a backend of CPAN::Patches

With 1, maybe don't need intermediate tooling module.

Speaking on CPAN::Patches:
1. Flatten CPAN::Patches arborescence? (fixed by "new backend" idea)
2. Make CPAN::Patches more more flexible in matching? (fixed by "new backend" idea)

## HOWTO
### Install patches
```
$ perl Makefile.PL
$ make 
$ make dist
$ cpm install --global CPANSec-Patches-0.01.tar.gz
```

### Install with patches
```
$ rm ~/.perl-cpm/ -rf; cpm install Acme::LSD --with-security-patches --reinstall
```

### Run
```
$ perl -I local/lib/perl5/ -MAcme::LSD -e 'print "aAaAaAaAaAa" x100;'
```


