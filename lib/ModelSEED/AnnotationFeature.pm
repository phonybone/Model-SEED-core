package ModelSEED::AnnotationFeature;
use Moose;
use ModelSEED::Role::DBObject;

with ( 'ModelSEED::Role::DBObject' => 
        { rose_class => 'ModelSEED::DB::AnnotationFeature' },
     );

1;
