#!/usr/bin/perl

use Template;
use Imager::QRCode;
use YAML::Syck qw(LoadFile);
use Digest::MD5 qw(md5_hex);
use Modern::Perl;
use Data::Dumper;

my @outbooks;
my ($inbooks) = LoadFile('books.yaml');

my $tt = Template->new({
    INCLUDE_PATH => '.',
}) || die "$Template::ERROR\n";

foreach my $b ( @{$inbooks} ) {
  my $url = $b->{'epub'};
  my $md5 = md5_hex($url);
  $b->{'epub_md5'} = $md5;
  # TODO Check if the image exists before generating it
  # TODO Find a fixed size
  `qrencode -l Q -o $md5.png "$url"`;
  push(@outbooks, $b);
}

my $vars = {
  books => \@outbooks, 
};
my $outfile = 'index.html';
$tt->process('index.tt', $vars, $outfile) || die $tt->error(), "\n";
