package ModelSEED::DB::Biomass;

use strict;
use Data::UUID;
use DateTime;

use base qw(ModelSEED::DB::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'biomasses',

    columns => [
        uuid    => { type => 'character', length => 36, not_null => 1 },
        modDate => { type => 'datetime' },
        locked  => { type => 'integer' },
        id      => { type => 'varchar', length => 32 },
        name    => { type => 'varchar', length => 255 },
    ],

    primary_key_columns => [ 'uuid' ],

    relationships => [
        biomass_compounds => {
            class      => 'ModelSEED::DB::BiomassCompound',
            column_map => { uuid => 'biomass_uuid' },
            type       => 'one to many',
        },

        models => {
            map_class => 'ModelSEED::DB::ModelBiomass',
            map_from  => 'biomass',
            map_to    => 'model',
            type      => 'many to many',
        },
    ],
);



__PACKAGE__->meta->column('uuid')->add_trigger(
    deflate => sub {
        my $uuid = $_[0]->uuid;
        if(ref($uuid) && ref($uuid) eq 'Data::UUID') {
            return $uuid->to_string();
        } elsif($uuid) {
            return $uuid;
        } else {
            return Data::UUID->new()->create_str();
        }   
});

__PACKAGE__->meta->column('modDate')->add_trigger(
   on_save => sub { return DateTime->now() });

1;

