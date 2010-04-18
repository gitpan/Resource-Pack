
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Resource::Pack',
                       'DISTNAME' => 'Resource-Pack',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.31'
                                               },
                       'AUTHOR' => 'Stevan Little <stevan.little@iinteractive.com>, Jesse Luehrs <doy at tozt dot net>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'tools for managing application resources',
                       'EXE_FILES' => [],
                       'VERSION' => '0.02',
                       'PREREQ_PM' => {
                                        'MooseX::Types::Path::Class' => '0.05',
                                        'LWP::UserAgent' => '0',
                                        'Test::Exception' => '0.21',
                                        'File::Copy::Recursive' => '0.38',
                                        'Bread::Board' => '0.12',
                                        'Moose' => '1.01',
                                        'MooseX::Types::URI' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{BUILD_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.56) };

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



