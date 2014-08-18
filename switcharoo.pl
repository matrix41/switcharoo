#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block

# Define
my $superstring;
my $parameter;
my $value;
my $temp;
my $temp2;

# Get filename from command line argument 
my $inputfile = $ARGV[0];

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
    # first iteration 
		for ( my $i = 0 ; $i < $#split_parameters ; $i++ )
		{
      ( $parameter, $value ) = split(/\s+/, $split_parameters[$i]);

      if ( $parameter =~ /^age$/ )
      {
      	$temp = $value;
      	$value = "null";
      }

      if ( $parameter =~ /^agelim$/ )
      {
      	$temp2 = $value;
      	$value = "null";
      }

      if ( defined($value) )
      {
        $split_parameters[$i] = "$parameter" . " " . "$value";
      }
      else
      {
        $split_parameters[$i] = "$parameter";
      }
		} # end of first iteration 

    # second iteration 
		for ( my $i = 0 ; $i < $#split_parameters ; $i++ )
		{
      ( $parameter, $value ) = split(/\s+/, $split_parameters[$i]);

      if ( $parameter =~ /^mass$/ )
      {
      	$value = $temp;
      }

      if ( $parameter =~ /^masslim$/ )
      {
      	$value = $temp2;
      }

      if ( defined($value) )
      {
        $split_parameters[$i] = "$parameter" . " " . "$value";
      }
      else
      {
        $split_parameters[$i] = "$parameter";
      }
		} # end of second iteration 

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
