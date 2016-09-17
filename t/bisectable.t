#!/usr/bin/env perl6
BEGIN %*ENV<PERL6_TEST_DIE_ON_FAIL> = 1;
%*ENV<TESTABLE> = 1;

use Test;
use lib ‘t/lib’;
use Testable;

my $t = Testable.new(bot => ‘./Bisectable.p6’);

# Help messages

$t.test(‘help message’,
        “{$t.bot-nick}, helP”,
        “{$t.our-nick}, Like this: bisectable6: old=2015.12 new=HEAD exit 1 if (^∞).grep(\{ last })[5] // 0 == 4 # RT128181”);

$t.test(‘help message’,
        “{$t.bot-nick},   HElp?  ”,
        “{$t.our-nick}, Like this: bisectable6: old=2015.12 new=HEAD exit 1 if (^∞).grep(\{ last })[5] // 0 == 4 # RT128181”);

$t.test(‘source link’,
        “{$t.bot-nick}: Source   ”,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘source link’,
        “{$t.bot-nick}:   sourcE?  ”,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘source link’,
        “{$t.bot-nick}:   URl ”,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘source link’,
        “{$t.bot-nick}:  urL?   ”,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘“bisect:” shortcut’,
        ‘bisect: url’,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘“bisect,” shortcut’,
        ‘bisect, url’,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘“bisect6:” shortcut’,
        ‘bisect6: url’,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘“bisect6,” shortcut’,
        ‘bisect6, url’,
        “{$t.our-nick}, https://github.com/perl6/whateverable”);

$t.test(‘“bisect” shortcut does not work’,
        ‘bisect url’);

$t.test(‘“bisect6” shortcut does not work’,
        ‘bisect6 url’);

# Basics

$t.test(‘bisect by exit code’,
        ‘bisect: exit 1 if (^∞).grep({ last })[5] // 0 == 4 # RT 128181’,
        /^ <{$t.our-nick}> ‘, Bisecting by exit code (old=2015.12 new=’ <.xdigit>**7 ‘). Old exit code: 0’ $/,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-03-18) https://github.com/rakudo/rakudo/commit/6d120ca”);

$t.test(‘inverted exit code’,
        ‘bisect: class A { has $.wut = [] }; my $a = A.new; $a.wut = [1,2,3]’,
        /^ <{$t.our-nick}> ‘, Bisecting by exit code (old=2015.12 new=’ <.xdigit>**7 ‘). Old exit code: 1’ $/,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-03-02) https://github.com/rakudo/rakudo/commit/fdd37a9”);

$t.test(‘bisect by exit signal’,
        ‘bisect: old=2015.10 new=2015.12 Buf.new(0xFE).decode("utf8-c8") # RT 126756’,
        “{$t.our-nick}, Bisecting by exit signal (old=2015.10 new=2015.12). Old exit signal: 0 (None)”,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2015-11-13) https://github.com/rakudo/rakudo/commit/3bbc922”);

$t.test(‘inverted exit signal’,
        ‘bisect: Buf.new(0xFE).decode("utf8-c8") # RT 126756’,
        /^ <{$t.our-nick}> ‘, Bisecting by exit signal (old=2015.12 new=’ <.xdigit>**7 ‘). Old exit signal: 11 (SIGSEGV)’ $/,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-04-01) https://github.com/rakudo/rakudo/commit/a87fb43”);

$t.test(‘bisect by output’,
        ‘bisect: say (^∞).grep({ last })[5] # same but without proper exit codes’,
        /^ <{$t.our-nick}> ‘, Bisecting by output (old=2015.12 new=’ <.xdigit>**7  ‘) because on both starting points the exit code is 0’ $/,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-03-18) https://github.com/rakudo/rakudo/commit/6d120ca”);

$t.test(‘nothing to bisect’,
        ‘bisect: say ‘hello world’; exit 42’,
        /^ <{$t.our-nick}> ‘, On both starting points (old=2015.12 new=’ <.xdigit>**7 ‘) the exit code is 42 and the output is identical as well’ $/,
        “{$t.our-nick}, Output on both points: hello world”);

$t.test(‘nothing to bisect, segmentation fault everywhere’,
        ‘bisect: old=2016.02 new=2016.03 Buf.new(0xFE).decode("utf8-c8")’,
        “{$t.our-nick}, On both starting points (old=2016.02 new=2016.03) the exit code is 0, exit signal is 11 (SIGSEGV) and the output is identical as well”,
        “{$t.our-nick}, Output on both points:”);

$t.test(‘large output is uploaded’,
        ‘bisect: .say for ^1000; exit 5’,
        /^ <{$t.our-nick}> ‘, On both starting points (old=2015.12 new=’ <.xdigit>**7 ‘) the exit code is 5 and the output is identical as well’ $/,
        “{$t.our-nick}, https://whatever.able/fakeupload”);

# Custom starting points

$t.test(‘custom starting points’,
        ‘bisect: old=2016.02 new 2016.03 say (^∞).grep({ last })[5]’,
        “{$t.our-nick}, Bisecting by output (old=2016.02 new=2016.03) because on both starting points the exit code is 0”,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-03-18) https://github.com/rakudo/rakudo/commit/6d120ca”);

$t.test(‘custom starting points using “bad” and “good” terms’,
        ‘bisect: good 2016.02 bad=2016.03 say (^∞).grep({ last })[5]’,
        “{$t.our-nick}, Bisecting by output (old=2016.02 new=2016.03) because on both starting points the exit code is 0”,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-03-18) https://github.com/rakudo/rakudo/commit/6d120ca”);

$t.test(‘swapped old and new revisions’,
        ‘bisect: old=2016.03 new 2016.02 say (^∞).grep({ last })[5]’,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, bisect init failure”);

# Special characters

$t.test(‘special characters’,
        ‘bisect: say (.chr for ^128).join’,
        /^ <{$t.our-nick}> ‘, On both starting points (old=2015.12 new=’ <.xdigit>**7 ‘) the exit code is 0 and the output is identical as well’ $/,
        “{$t.our-nick}, Output on both points: ” ~ ‘␀␁␂␃␄␅␆␇␈␉␤␋␌␍␎␏␐␑␒␓␔␕␖␗␘␙␚␛␜␝␞␟ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~␡’);

$t.test(‘␤ works like an actual newline’,
        ‘bisect: # newline test ␤ say ‘hello world’; exit 42’,
        /^ <{$t.our-nick}> ‘, On both starting points (old=2015.12 new=’ <.xdigit>**7 ‘) the exit code is 42 and the output is identical as well’ $/,
        “{$t.our-nick}, Output on both points: hello world”);

# URLs

$t.test(‘fetching code from urls’,
        ‘bisect: https://gist.githubusercontent.com/AlexDaniel/147bfa34b5a1b7d1ebc50ddc32f95f86/raw/9e90da9f0d95ae8c1c3bae24313fb10a7b766595/test.p6’,
        “{$t.our-nick}, Successfully fetched the code from the provided URL.”,
        /^ <{$t.our-nick}> ‘, On both starting points (old=2015.12 new=’ <.xdigit>**7 ‘) the exit code is 0 and the output is identical as well’ $/,
        “{$t.our-nick}, Output on both points: url test”);

$t.test(‘wrong url’,
        ‘bisect: http://github.org/sntoheausnteoahuseoau’,
        “{$t.our-nick}, It looks like a URL, but for some reason I cannot download it (HTTP status line is 404 Not Found).”);

$t.test(‘wrong mime type’,
        ‘bisect: https://www.wikipedia.org/’,
        “{$t.our-nick}, It looks like a URL, but mime type is ‘text/html’ while I was expecting something with ‘text/plain’ or ‘perl’ in it. I can only understand raw links, sorry.”);

# Extra tests

$t.test(‘another working query’,
        ‘bisect: new=d3acb938 try { NaN.Rat == NaN; exit 0 }; exit 1’,
        “{$t.our-nick}, Bisecting by exit code (old=2015.12 new=d3acb93). Old exit code: 0”,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-05-02) https://github.com/rakudo/rakudo/commit/e2f1fa7”);

$t.test(‘last working query’, # keep it last in this file
        ‘bisect: for ‘q b c d’.words -> $a, $b { }; CATCH { exit 0 }; exit 1’,
        /^ <{$t.our-nick}> ‘, Bisecting by exit code (old=2015.12 new=’ <.xdigit>**7 ‘). Old exit code: 0’ $/,
        “{$t.our-nick}, bisect log: https://whatever.able/fakeupload”,
        “{$t.our-nick}, (2016-03-01) https://github.com/rakudo/rakudo/commit/1b6c901”);

END {
    $t.end;
    sleep 1;
}

done-testing;
