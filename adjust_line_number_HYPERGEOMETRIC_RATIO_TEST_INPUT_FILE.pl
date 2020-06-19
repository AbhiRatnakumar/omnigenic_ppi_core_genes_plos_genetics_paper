#!/usr/bin/perl


&loop_though_all_the_lines;

sub loop_though_all_the_lines
{
	foreach my $file (`ls HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_[a-z][a-z]`)
	{
		chomp($file);
		&adjust_line_number($file);
	}
}


sub adjust_line_number
{
	my $file_in = shift;
	open(INFO, $file_in);

	my $file_out = $file_in."_line_count_adjusted.txt";
	open(OUT, ">$file_out");

	print OUT "line_count\tstudy\tno_gwas_hits\tno_in_ppi_family\tintersection\tline\tloci_line\tcount_unique_loci\tcount_of_loci\n";

	my $line_count = 1;
	while(<INFO>)
	{
		chomp;
		my ($old_line_count, $rest_of_the_line) = split(/\t/,$_,2);	
		if(!($_ =~ /line_count/))
		{
			print OUT "$line_count\t$rest_of_the_line\n";	
			$line_count++;
		}
	}
	close(INFO);
	close(OUT);
}
