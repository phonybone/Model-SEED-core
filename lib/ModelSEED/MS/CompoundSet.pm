package ModelSEED::MS::CompoundSet;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;
use Data::UUID;
use DateTime;

# Attributes
has 'uuid' => ( is => 'rw', isa => 'Str', builder => '_buildUUID' );
has 'modDate' => ( is => 'rw', isa => 'Str', builder => '_buildModDate' );
has 'locked' => ( is => 'rw', isa => 'Int', default => 0 );
has 'name' => ( is => 'rw', isa => 'Str' );
has 'searchname' => ( is => 'rw', isa => 'Str' );
has 'class' => ( is => 'rw', isa => 'Str' );
has 'type' => ( is => 'rw', isa => 'Str' );
# Relationships
has 'compounds' => ( is => 'rw', default => sub { return []; },
    isa => 'ArrayRef[ModelSEED::MS::Compound');

sub BUILDARGS {
    my ($self, $params) = @_;
    my $attrs = $params->{attributes};
    my $rels  = $params->{relations} || {};
    if(defined($attrs)) {
        map { $params->{$_} = $attrs->{$_} } @$attrs;
        delete $params->{attributes};
    }
    my $bio = $params->{biochemistry}; 
    delete $params->{biochemistry};
    # pretty ugly
    foreach my $rel (keys %$rels) {
        if($rel eq 'compounds') {
            map { $_ = $bio->getCompound(
            { uuid => $_ }) } @{$rels->{$rel}};
        }
        $params->{$rel} = $rels->{$rel};
    }
    delete $params->{relations};
    return $params;
}

sub _buildUUID { return Data::UUID->new()->create_str(); }
sub _buildModDate { return DateTime->now(); }

__PACKAGE__->meta->make_immutable;
1;
