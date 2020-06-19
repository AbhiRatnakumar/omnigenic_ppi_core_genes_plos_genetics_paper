#!/usr/bin/perl


my %loci_gene_count = ();
my %remove_loci = ();


my $file_removed = "REMOVED_from_step5.txt";
open(REMOVED, ">$file_removed");

&read_in_table;
&apply_filter;

close(REMOVED);

sub apply_filter
{
 	my $file_in = "check4.txt";
        open(INFO, $file_in);

	my $file_out = "check5.txt";
        open(OUT, ">$file_out");

        print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\n";
	while(<INFO>)
        {
                chomp;
                my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			if(!exists $remove_loci{$loci_id})
			{
				print OUT "$_\n";	
                	}
			else
			{
				print REMOVED "$_\n";
			}
		}
        }
        close(OUT);
}		

sub read_in_table
{
	my $file_in = "check4.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			$loci_gene_count{$loci_id}{$gene} = $gene;
		}
	}
	foreach my $loci ( sort keys %loci_gene_count )
        {
                my $count_genes_in_loci = 0;
                for my $gene ( sort keys %{ $loci_gene_count{$loci} } )
                {
                        $count_genes_in_loci++;
                }
                if($count_genes_in_loci > 2)
                {
			 $remove_loci{$loci} = $loci;
                }
        }
	close(INFO);
}	
