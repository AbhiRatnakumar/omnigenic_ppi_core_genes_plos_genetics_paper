#!/usr/bin/perl



my %core_gene_locs_hash = ();
my %snp_locs_hash = ();
my %core_genes_hash = ();


&make_core_gene_locs_hash;
&make_snp_locs_hash;
&make_core_genes_hash;
&get_distance;

sub get_distance
{
	my $file_in = "MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt";
	open(INFO, $file_in);

	my $file_out = "Distance_bw_core_genes_and_the_gwas_hits_the_core_genes_were_detected_from.txt";
	open(OUT, ">$file_out");

	my $file_distance = "Couldnt_get_distance.txt";
	open(DISTANCE, ">$file_distance");

	while(<INFO>)
	{
		chomp;
		my ($junk, $ppi_name, $junk1, $junk2, $junk3, $junk4, $list_of_snps, $junk5) = split(/\t/,$_,8);
		if(exists $core_genes_hash{$ppi_name})
		{
			my @cols = split(/,/,$list_of_snps);
			for(my $i=0; $i<@cols; $i++)
			{
				if((exists $core_gene_locs_hash{$ppi_name})&&(exists $snp_locs_hash{$cols[$i]})) 
				{
					print OUT "$core_gene_locs_hash{$ppi_name}\t$snp_locs_hash{$cols[$i]}\n";
				}
				else
				{
					print DISTANCE "$cols[$i]\n";
				}
			}
		}		
	}
	close(INFO);
	close(OUT);
	close(DISTANCE);
}



sub make_core_genes_hash
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($Study_Accession, $junk0, $Core_Gene, $junk) = split(/\t/,$_,4);
		if(!($Study_Accession =~ /Study/))
		{
			my $core_gene = $Study_Accession."_".$Core_Gene."_ppi_family";
			$core_genes_hash{$core_gene} = $core_gene;
		}
	}
	close(INFO);
}



sub make_snp_locs_hash
{
	my $file_in = "SNP_locations_from_GWAS_CATALOG_for_476_studies_with_core_genes_with_locations.bed";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($chr, $start, $end, $junk, $id) = split(/\t/,$_);
		$snp_locs_hash{$id} = $_;
	}
	close(INFO);
}

sub make_core_gene_locs_hash
{
	my $file_in = "CORE_GENE_locations_bed_file_for_476_studies_with_core_genes.bed";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($chr, $start, $end, $id) = split(/\t/,$_);
		$core_gene_locs_hash{$id} = $_;		
	}
	close(INFO);
}

