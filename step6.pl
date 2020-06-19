#!/usr/bin/perl


my %loci_hash = ();
my %genes_hash = ();
my %keep_hash = ();
my %all_study_accessions = ();

my $file_removed = "REMOVED_from_step6.txt";
open(REMOVED, ">$file_removed");

&read_in_table;
&apply_filter;

close(REMOVED);

sub apply_filter
{
 	my $file_in = "check5.txt";
        open(INFO, $file_in);

	my $file_out = "check6.txt";
        open(OUT, ">$file_out");

        print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\n";
	while(<INFO>)
        {
                chomp;
                my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			my $study_accession = $study_accession;
			if(exists $keep_hash{$study_accession})
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
	my $file_in = "check5.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{	
			my $study_accession = $study_accession;
			$loci_hash{$study_accession}{$loci_id} = $loci_id;
                  	$genes_hash{$study_accession}{$gene} = $gene;
                     	$all_study_accessions{$study_accession} = $study_accession;
                }
        }
        foreach my $study_accession ( sort keys %all_study_accessions )
        {
                my $count_loci = 0;
                my $count_genes = 0;
                if(exists $loci_hash{$study_accession})
                {
                        for my $unique_id ( sort keys %{ $loci_hash{$study_accession} } )
                        {
                                $count_loci++;
                        }
                }
                if(exists $genes_hash{$study_accession})
                {
                        for my $gene ( sort keys %{ $genes_hash{$study_accession} } )
                        {
                                $count_genes++;
                        }
                }
                #if((($count_loci >= 4)&&($count_loci <= 200))&&(($count_genes >= 4)&&($count_genes <= 200)))
                #{
                         $keep_hash{$study_accession} = $study_accession;
                #}
        }
	close(INFO);
}

