#!/usr/bin/perl
use List::MoreUtils qw(uniq);

my %hash = ();
my $file_out = "check2.txt";
open(OUT, ">$file_out");

print OUT "study_accession\tunique_id\tloci_id\tpublication_id\tdisease_trait\tp_value\todds_ratio\tbeta_coefficient\tgene\tsnp_platform\tancestry\n";

&read_in_file;
&print_out;

close(OUT);

sub print_out
{
	foreach my $id (keys %hash)
	{
		print OUT "$hash{$id}->{LINE}\n";
	}
}

sub read_in_file
{
	my $file_in = "check1.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession,$unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
		if(!($unique_id =~ /unique_id/))
		{
			my $id = $study_accession."_".$gene;
			if(exists $hash{$id})
			{
				if($p_value < $hash{$id}->{PVALUE})
				{
					$hash{$id}->{UNIQUE_ID}=$unique_id; 		
					$hash{$id}->{PVALUE}=$p_value; 		
					$hash{$id}->{LINE}=$_; 		
				}
			}
			else
			{
				my $rec = {
						UNIQUE_ID => $unique_id,
						PVALUE => $p_value,
						LINE => $_
				  	 };
				$hash{$id} = $rec;
			}	
		}
	}
	close(INFO);
}
