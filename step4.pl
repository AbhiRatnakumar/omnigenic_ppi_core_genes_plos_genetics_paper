#!/usr/bin/perl


my %publication_hash = ();
my %remove_study = ();

my $file_removed = "REMOVED_from_step4.txt";
open(REMOVED, ">$file_removed");


&read_in_table;
&apply_filter;

close($file_removed);

sub apply_filter
{
 	my $file_in = "check3.txt";
        open(INFO, $file_in);

	my $file_out = "check4.txt";
        open(OUT, ">$file_out");

        print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\n";
	while(<INFO>)
        {
                chomp;
                my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			my $study_accession = $study_accession;
			if(!exists $remove_study{$study_accession})
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
	my $file_in = "check3.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			my $study_accession = $study_accession;
			$publication_hash{$publication_id}{$study_accession} = $study_accession;
		}
	}
	close(INFO);
	foreach my $publication ( sort keys %publication_hash )
        {
                my $count_no_studies_in_publication = 0;
                for my $study ( sort keys %{ $publication_hash{$publication} } )
                {
                        $count_no_studies_in_publication++;
                }
                #if($count_no_studies_in_publication > 6)
                #{
                #	for my $study ( sort keys %{ $publication_hash{$publication} } )
                #      	{
                #        	$remove_study{$study} = $study;
                #        }
                #}
        }
}	
