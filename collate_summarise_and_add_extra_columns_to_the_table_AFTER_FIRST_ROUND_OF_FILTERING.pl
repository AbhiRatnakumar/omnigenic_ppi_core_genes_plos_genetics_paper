#!/usr/bin/perl


my %loci_hash = ();
my %genes_hash = ();

my %count_of_genes_per_study = ();
my %count_of_loci_per_study = ();


my $file_study = "disease_study_STATISTICS_after_first_round_of_filtering.txt";
open(DISEASE_STUDY, ">$file_study");

print DISEASE_STUDY "disease_study\tcount_of_loci\tcount_of_genes\n";


&read_in_table;
&count_no_loci_and_genes_per_study;


sub read_in_table
{
 	my $file_in = "check5_R_friendly.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
              	my ($study_accession, $unique_id, $loci_id, $publication, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
                if(!($unique_id =~ /unique_id/))
                {
			$loci_hash{$study_accession}{$loci_id} = $gene;
                	$genes_hash{$study_accession}{$gene} = $gene;
		}
	}
	close(INFO);
}


sub count_no_loci_and_genes_per_study
{
	foreach my $study_accession ( sort keys %loci_hash )
	{
		my $count_loci = 0;
		my $count_genes = 0;
      		for my $loci_id ( sort keys %{ $loci_hash{$study_accession} } )
        	{
            		$count_loci++;
        	}
		for my $gene ( sort keys %{ $genes_hash{$study_accession} } )
                {
                        $count_genes++;
                }
		print DISEASE_STUDY "$study_accession\t$count_loci\t$count_genes\n";	
	}
}
