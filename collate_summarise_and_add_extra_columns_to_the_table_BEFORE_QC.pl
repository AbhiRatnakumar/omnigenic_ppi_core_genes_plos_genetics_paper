#!/usr/bin/perl


my %publication_hash = ();
my %loci_gene_count = ();
my %count_of_genes_per_loci = ();
my %disease_loci_hash = ();

my $file_publications = "publications_STATISTICS_HGNC.txt";
open(PUBLICATION, ">$file_publications");

print PUBLICATION "publication\tcount_of_studies\n";

my $file_loci = "loci_STATISTICS_HGNC.txt";
open(LOCI, ">$file_loci");

print LOCI "loci\tcount_of_genes\n";


&read_in_table;
&count_no_genes_per_loci;
&count_no_studies_per_publication;


close(PUBLICATION);
sub read_in_table
{
 	my $file_in = "check1_R_friendly.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
		my ($study_accession, $unique_id,	$loci_id, $publication,	$disease_trait,	$p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);   
		if(!($unique_id =~ /unique_id/))
		{
			my $study_accession = $study_accession;
			$publication_hash{$publication}{$study_accession} =$publication; 
               		$loci_gene_count{$loci_id}{$gene} = $gene;
		}
	}
}

 
sub count_no_studies_per_publication
{
	foreach my $publication ( sort keys %publication_hash )
        {
                my $count_no_studies_in_publication = 0;
                for my $study ( sort keys %{ $publication_hash{$publication} } )
                {
                        $count_no_studies_in_publication++;
                }
		print PUBLICATION "$publication\t$count_no_studies_in_publication\n";
	}
}


sub count_no_genes_per_loci
{
        foreach my $loci ( sort keys %loci_gene_count )
        {
                my $count_genes_in_loci = 0;
		for my $gene ( sort keys %{ $loci_gene_count{$loci} } )
                {
                        $count_genes_in_loci++;
                }
        	print LOCI "$loci\t$count_genes_in_loci\n";
	}
}
