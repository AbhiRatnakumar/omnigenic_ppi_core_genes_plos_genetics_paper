#!/usr/bin/perl



&remove_lines_with_one_overlap;

sub remove_lines_with_one_overlap
{
	my $file_in = "HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies.txt";
	open(INFO, $file_in);

	my $file_out = "HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt";
	open(OUT, ">$file_out");

	while(<INFO>)
	{
		chomp;
		my ($line_count, $ppi_family, $no_gwas_hits, $ppi_count, $overlap, $rest_of_the_line) = split(/\t/,$_);
		if(!($overlap == 1))
		{
			print OUT "$_\n";
		}
	}
	close(INFO);
	close(OUT);
}
