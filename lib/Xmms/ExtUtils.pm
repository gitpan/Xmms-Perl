package Xmms::ExtUtils;

use strict;

sub inc {
    chomp(my $inc = `gtk-config --cflags`);
    $inc;
}

sub libs {
    chomp(my $libs = `gtk-config --libs`);
    $libs ||= "-L/usr/X11R6/lib -lgtk -lgdk -lglib -lX11 -lXext";
    $libs =~ s/-rdynamic//;
    $libs .= " -lxmms";
    $libs;
}

1;
__END__
