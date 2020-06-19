#!/usr/bin/perl
use List::MoreUtils qw(uniq);

my %done = ();
my %done_print = ();
my %done_odds_ratio = ();
my %remove = ();
my %table = ();
my %hgnc_hash = ();
my %snp_platform_hash = ();
my %raw_ancestry_hash = ();
my %ancestry_hash = ();
my %remove_study_accession_with_multiple_ancestries = ();

my $file_out = "check1.txt";
open(OUT, ">$file_out");

print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\n";

my $file_removed = "REMOVED_from_step1.txt";
open(REMOVED, ">$file_removed");

&make_ancestry_hash;
&detect_study_accessions_associated_with_multiple_ancestry_categories;
&clean_ancestry_hash;
&make_hgnc_hash;
&make_hash_of_largest_snp_platform;
&loop_thru_gwas_catalog;
&print_out_table;

close(OUT);
close(REMOVED);

sub print_out_table
{
	foreach my $unique_identifier ( sort {$a cmp $b } keys %table ) 
	{
		if(!exists $remove{$unique_identifier})
		{
     			for my $line ( sort {$a cmp $b} keys %{ $table{$unique_identifier} } ) 
			{		
				if(!exists $done_print{$line})
				{
					print OUT "$line\n";
				}
				$done_print{$line} = $lien;
			}
		}
		else
		{
			for my $line ( sort {$a cmp $b} keys %{ $table{$unique_identifier} } )
                        {
                                print REMOVED "$line\n";
                        }
		}
	}	
}


sub loop_thru_gwas_catalog
{
	my $file_in = "gwas_catalog_v1.0.2-associations_e93_r2018-08-28.tsv";
	open(INFO, $file_in);

	# the unique identifier, is the pubmed id, the disease/trait, the strongest snp risk allele
	# cols, 2, 8, 21 and
	#cut -f 14,15,30,31,33
	# REPORTED GENE(S)	MAPPED_GENE	P-VALUE (TEXT)	OR or BETA	PLATFORM [SNPS PASSING QC]
	while(<INFO>)
	{
		chomp;
		my @cols = split(/\t/,$_);
		my $pubmed_id = $cols[1];
		my $study_accession = $cols[36];
		my $disease_trait = $cols[7];
		my $strongest_snp_risk_allele = $cols[20];
		my $unique_identifier = $study_accession."_".$strongest_snp_risk_allele;
		my $study_accession = $study_accession;
		my $reported_genes = $cols[13];
		my $mapped_genes = $cols[14];
		my $p_value_text = $cols[29];
		my $p_value = $cols[27];
		my $odds_ratio_beta = $cols[30];
		my $confidence_interval = $cols[31];
		my $snp_platform = $cols[32];
		my $merged_string_of_mapped_and_reported_genes = $mapped_genes." ".$reported_genes;
		$merged_string_of_mapped_and_reported_genes =~ s/ - / /g;
		$merged_string_of_mapped_and_reported_genes =~ s/,//g;
		my @genes = split(/ /,$merged_string_of_mapped_and_reported_genes);
		my @unique_genes = uniq @genes;
		if((exists($snp_platform_hash{$pubmed_id}))&&($snp_platform eq $snp_platform_hash{$pubmed_id}))
		{
			if(($p_value_text eq "")&&($odds_ratio_beta))
			{
				for(my $i=0; $i<@unique_genes; $i++)
				{
					if(exists $hgnc_hash{$unique_genes[$i]})
					{
						my $gene = $unique_genes[$i];
						my $new_unique_identifier = $unique_identifier."_".$gene;
						my $odds_ratio = "NA";
						my $beta_coefficient = "NA";
						if(($confidence_interval =~ /increase/)||($confidence_interval =~ /decrease/))
						{
							$beta_coefficient = $odds_ratio_beta;
						}
						else
						{
							$odds_ratio = $odds_ratio_beta;	
						}
						if((exists $ancestry_hash{$study_accession})&&(!exists $remove_study_accession_with_multiple_ancestries{$study_accession}))
						{
							my $ancestry = $ancestry_hash{$study_accession};
							if($ancestry eq "Hispanic or Latin American")
							{
								my $line = "$study_accession\t$new_unique_identifier\t$unique_identifier\t$pubmed_id\t$disease_trait\t$p_value\t$odds_ratio\t$beta_coefficient\t$unique_genes[$i]\t$snp_platform\t$ancestry";
								$table{$new_unique_identifier}{$line} = $line;
							}
						}
						if(!$done{$new_unique_identifier})
						{
							$done{$new_unique_identifier} = $p_value;
						}
						elsif($p_value != $done{$new_unique_identifier})
						{
							$remove{$new_unique_identifier} = $unique_identifier;
						}
						if(!$done_odds_ratio{$new_unique_identifier})
                                                {
                                                        $done_odds_ratio{$new_unique_identifier} = $odds_ratio_beta;
                                                }
                                                elsif($odds_ratio_beta != $done_odds_ratio{$new_unique_identifier})
                                                {
                                                        $remove{$new_unique_identifier} = $unique_identifier;
                                                }
					}
				}
			}
		}
	}
	close(INFO);
}



sub make_ancestry_hash
{
	my $file_in = "gwas_catalog-ancestry_r2018-08-28.tsv";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($STUDY_ACCCESSION, $PUBMEDID, $FIRST_AUTHOR, $DATE, $INITIAL_SAMPLE_DESCRIPTION, $REPLICATION_SAMPLE_DESCRIPTION, $STAGE, $NUMBER_OF_INDIVDUALS, $BROAD_ANCESTRAL_CATEGORY, $COUNTRY_OF_ORIGIN, $COUNTRY_OF_RECRUITMEN, $ADDITONAL_ANCESTRY_DESCRIPTION) = split(/\t/,$_);
		$raw_ancestry_hash{$STUDY_ACCCESSION}{$BROAD_ANCESTRAL_CATEGORY} = $BROAD_ANCESTRAL_CATEGORY;
	}
	close(INFO);
}

sub detect_study_accessions_associated_with_multiple_ancestry_categories
{
        foreach my $study_accession ( keys %raw_ancestry_hash )
        {
                my $count_ancestries = 0;
                my $line = "";
                for my $ancestry ( keys %{ $raw_ancestry_hash{$study_accession} } )
                {
                        if(!$line)
                        {
                                $line = $ancestry;
                        }
                        else
                        {
                                $line = $line.",".$ancestry;
                        }
                        $count_ancestries++;
                }
                if($count_ancestries > 1 )
                {
                        $remove_study_accession_with_multiple_ancestries{$study_accession} = $study_accession;
                }
        }
}

sub clean_ancestry_hash
{
        foreach my $study_accession ( keys %raw_ancestry_hash )
        {
                for my $ancestry ( keys %{ $raw_ancestry_hash{$study_accession} } )
                {
			if(!exists $remove_study_accession_with_multiple_ancestries{$study_accession})
			{
				if(exists $ancestry_hash{$study_accession})
				{
					print "error\t$study_accession\n";
				}
				$ancestry_hash{$study_accession} = $ancestry;
			}	
		}
	}
}


sub make_hash_of_largest_snp_platform
{
	my $file_in = "SNP_platform_for_each_publication_largest_SNP_platform.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($pubmed_id, $snp_platform) = split(/\t/,$_);
		$snp_platform_hash{$pubmed_id} = $snp_platform;
	}
	close(INFO);
}

sub make_hgnc_hash
{
	my $file_in = "FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt";
	open(INFO, $file_in);
	
	while(<INFO>)
	{
		chomp;
		$hgnc_hash{$_} = $_;
	}
	close(INFO);
}
