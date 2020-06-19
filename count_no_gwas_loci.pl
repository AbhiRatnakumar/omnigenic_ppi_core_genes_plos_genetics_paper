#!/usr/bin/perl

my %hash = ();

# count the number of gwas hits for each disease id
# then print it out to the file: NUMBER_of_GWAS_HITS_PER_DISEASE.txt 

&count_ppi_counts;
&print_out_top_gwas_hits;

# This file contains the disease ids for each of the 293 studies
# The second column contaihs the number of gwas hits per disease study
#   
sub print_out_top_gwas_hits
{
	my $file_out = "NUMBER_of_GWAS_LOCI_PER_DISEASE.txt";
	open(OUT, ">$file_out");
	foreach my $study_accession ( keys %hash ) 
	{
		my $count = 0;
     		for my $role ( keys %{ $hash{$study_accession} } ) 
		{
			$count++;
		}
		if(!($study_accession =~ /study_accession/))
		{
			print OUT "$study_accession\t$count\n";
		}
	}
	close(OUT);
}

# This file has the study_accession which corresponds to one of teh 293 diseases
# The second column is the efo term
# The third column is the parent term 
# The fourth column is the gene 
sub count_ppi_counts
{
	my $file_in = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in);
	
	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $efo_term, $parent_term, $gene, $loci_id) = split(/\t/,$_);
		if(!($study_accession =~ /study_accession/))
		{
			$hash{$study_accession}{$loci_id} = $loci_id;
		}
	}
	close(INFO);
}



