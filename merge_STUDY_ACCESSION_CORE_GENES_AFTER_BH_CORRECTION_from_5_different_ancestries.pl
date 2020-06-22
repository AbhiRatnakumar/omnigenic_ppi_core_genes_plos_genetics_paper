#!/usr/bin/perl


my $file_out = "MERGED_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt";
open(OUT, ">$file_out");

print OUT "study_accession\tdisease_trait\tcore_gene\tp_value\traw_p_value\tancestry\n";


&merge_files("European", "european/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt");
&merge_files("South Asian", "south_asian/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt");
&merge_files("East Asian", "east_asian/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt");
&merge_files("African American or Afro-Caribbean", "african/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt");
&merge_files("Hispanic or Latin American", "hispanic/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt");

close(OUT);

sub merge_files
{
	my $ancestry = shift;
	my $file_in = shift;
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $core_gene, $p_value, $raw_p_value, $type) = split(/\t/,$_);
		if(!($study_accession =~ /study_accession/))
		{
			
			print OUT "$study_accession\t$disease_trait\t$core_gene\t$p_value\t$raw_p_value\t$ancestry\n";
		}
	}
	close(INFO);
}
