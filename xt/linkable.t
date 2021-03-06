#!/usr/bin/env perl6
BEGIN %*ENV<PERL6_TEST_DIE_ON_FAIL> = 1;
%*ENV<TESTABLE> = 1;

use lib <lib xt/lib>;
use Test;
use IRC::Client;
use Testable;

my $t = Testable.new: bot => ‘Linkable’;

$t.common-tests: help => ‘Like this: R#1946 D#1234 MOAR#768 NQP#509 SPEC#242 RT#126800 S09:320 524f98cdc’;

$t.shortcut-tests: (),
                   <link link, link:>;


# .bots command
$t.test(:!both, ‘.bots command’,
        ‘.bots’,
        “{$t.our-nick}, Docs for all whateverable bots: https://github.com/Raku/whateverable/wiki”);


# GitHub
$t.test(:!both, ‘github (rakudo)’,
        ‘R#1946’,
        ‘R#1946 [closed]: https://github.com/rakudo/rakudo/issues/1946 %(), @(), $() are evil/weird’);

$t.test(:!both, ‘github (messages not repeated)’,
        ‘R#1946’);

$t.test(:!both, ‘github (docs)’,
        ‘D#577’,
        ‘D#577 [closed]: https://github.com/Raku/doc/issues/577 [docs] Rewrite the example so that it has no wombles’);

$t.test(:!both, ‘github (moarvm)’,
        ‘MOAR#768’,
        ‘MOAR#768 [closed]: https://github.com/MoarVM/MoarVM/issues/768 Buncha warnings when compiling on Win10 using Strawberry Perl suite's compiler’);

$t.test(:!both, ‘github (nqp)’,
        ‘NQP#509’,
        ‘NQP#509 [closed]: https://github.com/Raku/nqp/issues/509 Role mixing is fussy’);

$t.test(:!both, ‘github (spec)’,
        ‘SPEC#242’,
        ‘SPEC#242 [open]: https://github.com/Raku/roast/issues/242 notandthen is untested’);

sleep 5;

# Same but directly
$t.test(:!both, ‘github (rakudo), directly’,
        “{$t.bot-nick}: R#1946”,
        ‘R#1946 [closed]: https://github.com/rakudo/rakudo/issues/1946 %(), @(), $() are evil/weird’);

$t.test(:!both, ‘github, directly (messages not repeated)’,
        “{$t.bot-nick}: R#1946”);

$t.test(:!both, ‘github (docs), directly’,
        “{$t.bot-nick}: D#577”,
        ‘D#577 [closed]: https://github.com/Raku/doc/issues/577 [docs] Rewrite the example so that it has no wombles’);

$t.test(:!both, ‘github (moarvm), directly’,
        “{$t.bot-nick}: MOAR#768”,
        ‘MOAR#768 [closed]: https://github.com/MoarVM/MoarVM/issues/768 Buncha warnings when compiling on Win10 using Strawberry Perl suite's compiler’);

$t.test(:!both, ‘github (NQP), directly’,
        “{$t.bot-nick}: NQP#509”,
        ‘NQP#509 [closed]: https://github.com/Raku/nqp/issues/509 Role mixing is fussy’);

$t.test(:!both, ‘github (spec), directly’,
        “{$t.bot-nick}: SPEC#242”,
        ‘SPEC#242 [open]: https://github.com/Raku/roast/issues/242 notandthen is untested’);

# RT
$t.test(:!both, ‘RT’,
        ‘RT#126800’,
        ‘RT#126800 [resolved]: Shaped arrays with negative sizes (my @a[-9999999999999999]) https://rt.perl.org/Ticket/Display.html?id=126800 https://rt-archive.perl.org/perl6/Ticket/Display.html?id=126800’);

$t.test(:!both, ‘RT (messages not repeated)’,
        ‘RT#126800’);

sleep 5;

$t.test(:!both, ‘RT, directly’,
        “{$t.bot-nick}: RT#126800”,
        ‘RT#126800 [resolved]: Shaped arrays with negative sizes (my @a[-9999999999999999]) https://rt.perl.org/Ticket/Display.html?id=126800 https://rt-archive.perl.org/perl6/Ticket/Display.html?id=126800’);

$t.test(:!both, ‘RT, directly (messages not repeated)’,
        ‘RT#126800’);


# Doc links (messages from Geth)

my $geth = IRC::Client.new(:nick(‘Geth’)
                              :host<127.0.0.1> :port(%*ENV<TESTABLE_PORT>)
                              :channels<#whateverable_linkable6>);
start $geth.run;
sleep 1;

$t.test(:!both, ‘doc links only work with a bot’,
        ‘¦ doc: a65db64a81 | (JJ Merelo)++ | doc/Language/operators.pod6’);

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘¦ doc: 0bcdbcd0cd | Coke++ | doc/Language/compilation.pod6’;

$t.test(:!both, ‘doc links’,
        ‘doesn't matter… this is just a message…’,
        ‘Link: https://docs.raku.org/language/compilation’);

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘¦ doc: 0bcdbcd0cd | Coke++ | doc/Language/compilation.pod6’;

$t.test(:!both, ‘doc links (messages not repeated)’,
        ‘blah, doesn't matter’);


# GitHub local links

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘¦ rakudo: Phixes #1457’;

$t.test(:!both, ‘local github links’,
        ‘blah, doesn't matter’,
        ‘RAKUDO#1457 [closed]: https://github.com/rakudo/rakudo/issues/1457 [BLOCKER] `where Foo|Bar` misoptimized for Junction arguments’);

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘¦ MoarVM: Fix #1163 and #919’;

$t.test(:!both, ‘more than one local github link’,
        ‘blah, doesn't matter’,
        "MOARVM#1163 [closed]: https://github.com/MoarVM/MoarVM/issues/1163 [Unicode/Encodings] gb2313 clang warnings",
        ‘MOARVM#919 [closed]: https://github.com/MoarVM/MoarVM/issues/919 Test fail on file-ops’);

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘¦ roast: Tests for rakudo/rakudo#1’;

$t.test(:!both, ‘link to another repo’,
        ‘blah, doesn't matter’,
        ‘RAKUDO#1 [closed]: https://github.com/rakudo/rakudo/issues/1 cc1: error: unrecognized command line option "-Wjump-missed-init"’);

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘<Geth> ¦ doc: Merge pull request #3183 from someuser/#3163’;

$geth.send: where => ‘#whateverable_linkable6’,
            text  => ‘<Geth> ¦ doc: testtest++ created pull request #3183: Foo bar baz’;

$t.test(:!both, ‘pull requests are ignored’, # these are handled by Geth
        ‘blah, doesn't matter’);

$geth.quit;
sleep 1;


# Old design docs

$t.test(:!both, ‘line number’,
        ‘S09:320’,
        ‘Link: https://design.Raku.org/S09.html#line_320’);

$t.test(:!both, ‘hierarchy’,
        ‘S32/IO:320’,
        ‘Link: https://design.Raku.org/S32/IO.html#line_320’);

$t.test(:!both, ‘text anchors’,
        ‘S05:Longest-token_matching’,
        ‘Link: https://design.Raku.org/S05.html#Longest-token_matching’);

$t.test(:!both, ‘extra text’,
        ‘S09:325 talks about something’,
        ‘Link: https://design.Raku.org/S09.html#line_325’);

$t.test(:!both, ‘more than one’,
        ‘S09:330 S32/IO:330’,
        ‘Link: https://design.Raku.org/S09.html#line_330’,
        ‘Link: https://design.Raku.org/S32/IO.html#line_330’);


# Commits

$t.test(:!both, ‘very short commit sha’,
        ‘6ec6f1eb’,
        ‘(2017-11-17) https://github.com/rakudo/rakudo/commit/6ec6f1eb29 Too bad, we hardly knew ya’);

$t.test(:!both, ‘basic commit with description’,
        ‘524f98cdc95c3d’,
        ‘(2017-01-10) https://github.com/MasterDuke17/Text-Diff-Sift4/commit/524f98cdc9 Make it 13x faster by making the code unreadable’);

$t.test(:!both, ‘ignore messages from eval bots’,
        ‘rakudo-moar 37ddd5984: OUTPUT: «Instant:1580038306␤»’);

# Everything at the same time

# XXX the order is not preserved, but maybe that's OK

sleep 5;

$t.test(:!both, ‘everything at the same time’,
        ‘R#1946 RT#126800 S09:320 524f98cdc95c3d’,
        ‘Link: https://design.Raku.org/S09.html#line_320’,
        ‘R#1946 [closed]: https://github.com/rakudo/rakudo/issues/1946 %(), @(), $() are evil/weird’,
        ‘RT#126800 [resolved]: Shaped arrays with negative sizes (my @a[-9999999999999999]) https://rt.perl.org/Ticket/Display.html?id=126800 https://rt-archive.perl.org/perl6/Ticket/Display.html?id=126800’,
        ‘(2017-01-10) https://github.com/MasterDuke17/Text-Diff-Sift4/commit/524f98cdc9 Make it 13x faster by making the code unreadable’);

sleep 5;

$t.test(:!both, :bridge, ‘everything at the same time (through the bridge)’,
        ‘R#1946 RT#126800 S09:320 524f98cdc95c3d’,
        ‘Link: https://design.Raku.org/S09.html#line_320’,
        ‘R#1946 [closed]: https://github.com/rakudo/rakudo/issues/1946 %(), @(), $() are evil/weird’,
        ‘RT#126800 [resolved]: Shaped arrays with negative sizes (my @a[-9999999999999999]) https://rt.perl.org/Ticket/Display.html?id=126800 https://rt-archive.perl.org/perl6/Ticket/Display.html?id=126800’,
        ‘(2017-01-10) https://github.com/MasterDuke17/Text-Diff-Sift4/commit/524f98cdc9 Make it 13x faster by making the code unreadable’);

sleep 5;

$t.test(:!both, ‘everything at the same time, more than once’,
        ‘524f98cdc R#1946 RT#126800 S09:320 R#1946 RT#126800 S09:320 R#1946 RT#126800 S09:320 524f98cdc95c3d’,
        ‘Link: https://design.Raku.org/S09.html#line_320’,
        ‘R#1946 [closed]: https://github.com/rakudo/rakudo/issues/1946 %(), @(), $() are evil/weird’,
        ‘RT#126800 [resolved]: Shaped arrays with negative sizes (my @a[-9999999999999999]) https://rt.perl.org/Ticket/Display.html?id=126800 https://rt-archive.perl.org/perl6/Ticket/Display.html?id=126800’,
        ‘(2017-01-10) https://github.com/MasterDuke17/Text-Diff-Sift4/commit/524f98cdc9 Make it 13x faster by making the code unreadable’);


$t.last-test;
done-testing;
END $t.end;

# vim: expandtab shiftwidth=4 ft=perl6
