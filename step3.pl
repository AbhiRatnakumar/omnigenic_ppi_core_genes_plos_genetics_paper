#!/usr/bin/perl


my %publication_hash = ();
my %loci_gene_count = ();
my %remove = ();
my %remove_study = ();

my %loci_hash = ();
my %genes_hash = ();
my %keep_hash = ();

my $file_removed = "REMOVED_from_step3.txt";
open(REMOVED, ">$file_removed");

&read_in_table;
&apply_filter;

close(REMOVED);

sub apply_filter
{
 	my $file_in = "check2.txt";
        open(INFO, $file_in);

	my $file_out = "check3.txt";
        open(OUT, ">$file_out");

        print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\n";

	while(<INFO>)
        {
                chomp;
                my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			if(!exists $remove{$unique_id})
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
	my $file_in = "check2.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id eq "unique_id"))
		{
			if($p_value > 5E-8)
			{
				$remove{$unique_id} = $unique_id;
			}
			if($unique_id =~ / x /)
			{
				$remove{$unique_id} = $unique_id;
			}
			if($unique_id =~ /\;/)
                	{
                        	$remove{$unique_id} = $unique_id;
                	}
		}
	}
	close(INFO);
}	
