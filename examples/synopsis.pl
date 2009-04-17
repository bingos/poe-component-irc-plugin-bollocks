  use strict;
  use warnings;
  use POE qw(Component::IRC Component::IRC::Plugin::Bollocks);

  my $nickname = 'Pointy' . $$;
  my $ircname = 'Pointy Haired Boss';
  my $ircserver = 'irc.bleh.net';
  my $port = 6667;
  my $channel = '#IRC.pm';

  my $irc = POE::Component::IRC->spawn(
        nick => $nickname,
        server => $ircserver,
        port => $port,
        ircname => $ircname,
        debug => 0,
        plugin_debug => 1,
        options => { trace => 0 },
  ) or die "Oh noooo! $!";

  POE::Session->create(
        package_states => [
                'main' => [ qw(_start irc_001) ],
        ],
  );

  $poe_kernel->run();
  exit 0;

  sub _start {
    # Create and load our CTCP plugin
    $irc->plugin_add( 'Bollocks' =>
        POE::Component::IRC::Plugin::Bollocks->new() );

    $irc->yield( register => 'all' );
    $irc->yield( connect => { } );
    undef;
  }

  sub irc_001 {
    $irc->yield( join => $channel );
    undef;
  }

