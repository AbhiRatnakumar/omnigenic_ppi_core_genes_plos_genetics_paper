#!/usr/bin/perl

my %hgnc_hash = ();
my %all_disease_sets = ();

&make_hgnc_hash;
&make_hash_of_all_diseases;
&make_ppi_counts_hash;

# after making a hgnc_hash with the list of proteins and the _ppi_family added to the protein names
# then read in each disease id and store it in a hash called all_disease_sets  
sub make_hash_of_all_diseases
{
	my $file_in = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $efo_term, $parent_term, $gene) = split(/\t/,$_);
		if(!($study_accession =~ /study_accession/))
		{
			$all_disease_sets{$study_accession} = $study_accession;
		}
	}
	close(INFO);
}

# Read in the String PPI network counts, a file that lists the number of nodes connected to each ppi family,
# and we have the ppi_family names for each gene, then we check if the ppi network node is in hgnc_hash
# Then we loop through the list of all disease ids, then for each disease id, and make a new disease id 
# we just just add to each ppi node name to the disease id
# we want to compare each disease id to all the protein nodes within the ppi network 
# since there are 10,996 nodes within the list of proteins, so each disease id should be mentionaed 10,996 times within the file
# So we have the number of proteins connected to each protein node within the String PPI network
sub make_ppi_counts_hash
{
	my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding_PPI_COUNTS.txt";
	open(INFO, $file_in);

	my $file_out = "PPI_COUNTS_GENE_LIST_for_each_DISEASE_ID.txt";
	open(OUT, ">$file_out");

	while(<INFO>)
	{
		chomp;
		my ($ppi_fam, $count) = split(/\t/,$_);
		if(exists $hgnc_hash{$ppi_fam})
		{
			foreach my $study_accession (keys %all_disease_sets)
			{
				my $new_id = $study_accession."_".$ppi_fam;		
				print OUT "$new_id\t$count\n";
				
			}
		}
	}
	close(INFO);
	close(OUT);
}

# read in the list of genes and then add the _ppi_family to the gene name, and store it in a hash
# so the hgnc hash has a list of genes with _ppi_family
sub make_hgnc_hash
{
	my $file_in = "FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my $ppi_name = $_;
		my $ppi_name = $ppi_name."_ppi_family";
		$hgnc_hash{$ppi_name} = $ppi_name;
	}
	close(INFO);
}
