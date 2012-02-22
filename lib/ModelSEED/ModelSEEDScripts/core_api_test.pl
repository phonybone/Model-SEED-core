use strict;
use warnings;

use Data::Dumper;
use Time::HiRes qw(time);
use Devel::Size qw(total_size);

use JSON::XS;

use ModelSEED::CoreApi;

my $bio_uuid = "DBB3B96A-3D63-11E1-94F6-C43F3D9902C7";
my $mapping_uuid = "6B7F20C0-3D64-11E1-94F6-C43F3D9902C7";

my $api = ModelSEED::CoreApi->new({
    database => "/home/paul/Documents/ModelSEEDCore/Model.db",
    driver   => "sqlite"
});

# test reactions
my $time = time;
my $rxns = $api->getReactions({biochemistry_uuid => $bio_uuid});
print "Got " . scalar @$rxns . " reactions in " . sprintf("%.3f", time - $time) . " seconds\n";

$time = time;
$rxns = $api->getReactions({
    biochemistry_uuid => $bio_uuid,
    query =>  [['reactions.uuid', 'A21570E0-3D63-11E1-94F6-C43F3D9902C7']]
});
print "Got " . scalar @$rxns . " reactions in " . sprintf("%.3f", time - $time) . " seconds\n";

$time = time;
my $rxn = $api->getReaction({
    uuid => "A21570E0-3D63-11E1-94F6-C43F3D9902C7", 
    biochemistry_uuid => $bio_uuid
});
print "Got reaction in " . sprintf("%.3f", time - $time) . " seconds\n";

$time = time;
$rxns = $api->getReactions({
    biochemistry_uuid => $bio_uuid,
    query => [['deltaG', '<', '10000000']]
});
print "Got " . scalar @$rxns . " reactions in " . sprintf("%.3f", time - $time) . " seconds\n";

# test compounds
$time = time;
my $cpds = $api->getCompounds({biochemistry_uuid => $bio_uuid});
print "Got " . scalar @$cpds . " compounds in " . sprintf("%.3f", time - $time) . " seconds\n";

$time = time;
my $cpd = $api->getCompound({
    uuid => "641122EE-3D63-11E1-94F6-C43F3D9902C7",
    biochemistry_uuid => $bio_uuid
});
print "Got compound in " . sprintf("%.3f", time - $time) . " seconds\n";

# test media
$time = time;
my $media = $api->getMedia({biochemistry_uuid => $bio_uuid});
print "Got " . scalar @$media . " media in " . sprintf("%.3f", time - $time) . " seconds\n";

# test reactionsets
$time = time;
my $reactionsets = $api->getReactionSets({biochemistry_uuid => $bio_uuid});
print "Got " . scalar @$reactionsets . " reaction sets in " . sprintf("%.3f", time - $time) . " seconds\n";

# test compoundsets
$time = time;
my $compoundsets = $api->getCompoundSets({biochemistry_uuid => $bio_uuid});
print "Got " . scalar @$compoundsets . " compound sets in " . sprintf("%.3f", time - $time) . " seconds\n";

# test compartments
$time = time;
my $compartments = $api->getCompartments({biochemistry_uuid => $bio_uuid});
print "Got " . scalar @$compartments . " compartments in " . sprintf("%.3f", time - $time) . " seconds\n";

# test biochemistry
$time = time;
my $biochem = $api->getBiochemistry({
    uuid => $bio_uuid,
    user => "master",
    with_all => 1
});
print "Got biochemistry in " . sprintf("%.3f", time - $time) . " seconds\n";
print total_size($biochem) . " bytes\n";

# test mapping
$time = time;
my $mapping = $api->getMapping({
    uuid => $mapping_uuid,
    user => "master",
    with_complexes => 1
});
print "Got mapping in " . sprintf("%.3f", time - $time) . " seconds\n";

sub file {
    $biochem->{relationships}->{reactions} = [$biochem->{relationships}->{reactions}->[0]];
    $biochem->{relationships}->{compounds} = [$biochem->{relationships}->{compounds}->[0]];
    $biochem->{relationships}->{media} = [$biochem->{relationships}->{media}->[0]];

    open OUT, ">out.txt";
    print OUT Dumper($biochem);
    close OUT;
}

exit;