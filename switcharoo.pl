#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block

# Define
my $superstring;
my $parameter;
my $value;

# Check if there are sufficient number of arguments
if ( @ARGV != 3 )
{
  print "Number of arguments you entered: " . scalar @ARGV . "\n";
  print "Syntax: ./switcharoo.pl FILENAME COLUMN_NAME NEW_VALUE\n\n";
  print "Example: ./switcharoo.pl HD_37124_b.edm plnmsinilim 0\n\n";
  exit;
}

# Get filename from command line argument 
my $inputfile = $ARGV[0];
my $targetfield = $ARGV[1];
my $newvalue = $ARGV[2];

# Declare new filehandle and associate it with filename 
open (my $fh, '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";

# Point array to filehandle.  
my @array = <$fh>;

# Close filehandle after filling array 
close ($fh);

# Array element 9 (ie the 10th row) is where the data starts.  
# my @split_parameters = split(/\|/, $array[9]);

my $j = 0;
foreach my $element (@array)
{
	my @split_parameters = split(/\|/, $element);
	if ( $split_parameters[0] =~ /^EDMT$/ )
	{
    # this FOR-loop will upack and iterate through all the parameter names 
		for ( my $i = 0 ; $i < $#split_parameters ; $i++ )
		{
      ( $parameter, $value ) = split(/\s+/, $split_parameters[$i]);

      if ( $parameter =~ /^$targetfield$/ )
      {
      	$value = "$newvalue";
      }

# I need this IF-block below to handle cases for EDMT tag and OBJECTID field
      if ( defined($value) )
      {
        $split_parameters[$i] = "$parameter" . " " . "$value";
      }
      else
      {
        $split_parameters[$i] = "$parameter";
      }
		} # end of FOR-loop iteration

    # now pack the parameters back up again
    for ( my $k = 0 ; $k < $#split_parameters ; $k++ )
    {
      $superstring .= $split_parameters[$k]."|";
    }
    $superstring .= "\n"; # have to add this newline character 
    $array[$j] = $superstring;

    #reset the $superstring for next iteration 
    $superstring = '';

	} # end of IF statement /^EDMT$/
  $j += 1;
} # end of FOREACH loop 

open (my $fh2, '>', $inputfile) or die "\nCould not open file '$inputfile' $!\n";
for ( my $m = 0 ; $m <= $#array ; $m++ )
{
  print $fh2 $array[$m];
}
close ($fh2);
