package ModelSEED::ModelessFeature;
use Moose;
use ModelSEED::Role::DBObject;

with ( 'ModelSEED::Role::DBObject' => 
        { rose_class => 'ModelSEED::DB::ModelessFeature' },
     );

1;
