#!/usr/bin/perl

my $file_out = "run_BH_multiple_testing_corrections_study_accessions.sh";
open(OUT, ">$file_out");

my $file_sort = "run_sort_by_p_value_after_BH_multiple_testing_corrections_study_accessions.sh";
open(SORT, ">$file_sort");

print SORT "#!/bin/bash\n\n";
print OUT "#!/bin/bash\n\n";

&loop_thru_the_files;

close(OUT);
close(SORT);

sub loop_thru_the_files
{
	foreach my $file (`ls *study_accession_raw_p_values.txt_reformatted_for_R.txt`)
	{
		chomp($file);
		my $new_file = $file."_BH_corrected.txt";
		my $new_file_sorted = $new_file."_sorted.txt";
		print OUT "Rscript adjust_p_value_mult_test_BH.R $file $new_file\n\n";
		print SORT "sort -g $new_file > $new_file_sorted \n\n";
	}
}
