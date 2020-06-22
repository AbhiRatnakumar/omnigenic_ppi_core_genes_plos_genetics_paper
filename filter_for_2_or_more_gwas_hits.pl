#!/usr/bin/perl

my %hash = ();

&make_hash;
&filter_it;

sub filter_it
{
	my $file_in = "MERGED_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt";
	open(INFO, $file_in);

	my $file_out = "MERGED_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION_filtered_for_2_or_more_GWAS_hits.txt";
	open(OUT, ">$file_out");

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $core_gene, $p_value, $raw_p_value, $ancestry) = split(/\t/,$_);
		my $ppi_name = $study_accession."_".$core_gene."_ppi_family";
		if(exists $hash{$ppi_name})
		{
			print OUT "$_\n";
		}
	}
	close(INFO);
	close(OUT);
}


sub make_hash
{
	my $file_in = "MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($junk1, $ppi_name, $junk3) = split(/\t/,$_,3);
		$hash{$ppi_name} = $ppi_name;
	}
	close(INFO);
}
