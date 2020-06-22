#!/usr/bin/perl



&make_S2_table;


sub make_S2_table
{	
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED_filter_out_GWAS_HITS_that_are_within_1_Mb.txt";
	open(INFO, $file_in);

	my $file_out = "S3_Table.txt";
	open(OUT, ">$file_out");

	print OUT "Study Accession\tDisease Trait\tCore Gene\tGWAS Hits\tRaw P-value\tadjusted P-value\tAncestry\tExcess PPI edges\tType\n";

	my $line = "";
	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $core_gene, $gwas_list, $raw_p_value, $adjusted_p_value, $ancestry, $excess_ppi_edges, $type) = split(/\t/,$_);
		if($type eq "UNTAGGED")
		{
			$type = "PPI only";
		}
		if($type eq "TAGGED")
		{
			$type = "PPI-GWAS";	
		}
		if($excess_ppi_edges eq "excess_PPI_edges")
		{
			$excess_ppi_edges = "has excess PPI edges";
		}
		$line = "$study_accession\t$disease_trait\t"."\"$core_gene\""."\t"."\"$gwas_list\""."\t$adjusted_p_value\t$raw_p_value\t$ancestry\t$excess_ppi_edges\t$type";
		if(!exists $done{$line})
		{
			print OUT "$line\n";
		}		
		$done{$line} = $line;
	}
	close(INFO);
	close(OUT);
}
