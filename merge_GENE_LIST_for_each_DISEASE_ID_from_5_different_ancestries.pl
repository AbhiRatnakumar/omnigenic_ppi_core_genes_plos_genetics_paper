#!/usr/bin/perl



my $file_out = "MERGED_GENE_LIST_for_each_DISEASE_ID.txt";
open(OUT, ">$file_out");

my $file_paper = "MERGED_GENE_LIST_for_each_DISEASE_ID_for_paper.txt";
open(PAPER, ">$file_paper");

print OUT "Study Accession\tDisease/Trait\tEFO Term\tParent Term\tGene\tUnique ID\tAncestry\n";
print PAPER "Study Accession\tDisease/Trait\tEFO Term\tParent Term\tGene\tUnique ID\tAncestry\n";

&merge_files("European", "european/GENE_LIST_for_each_DISEASE_ID.txt");
&merge_files("South Asian", "south_asian/GENE_LIST_for_each_DISEASE_ID.txt");
&merge_files("East Asian", "east_asian/GENE_LIST_for_each_DISEASE_ID.txt");
&merge_files("African American or Afro-Caribbean", "african/GENE_LIST_for_each_DISEASE_ID.txt");
&merge_files("Hispanic or Latin American", "hispanic/GENE_LIST_for_each_DISEASE_ID.txt");

close(OUT);
close(PAPER);

sub merge_files
{
	my $ancestry = shift;
	my $file_in = shift;
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		if(!($_ =~ /study_accession/))
		{
			print OUT "$_\t$ancestry\n";
			my ($Study_Accession, $Disease_Trait, $EFO_Term, $Parent_Term, $Gene, $Unique_ID) = split(/\t/,$_);		
			my $new_Disease_Trait = $Disease_Trait;
			$new_Disease_Trait =~ s/_/ /g;
			my $new_EFO_Term = $EFO_Term;
                        $new_EFO_Term =~ s/_/ /g;
			my $new_Parent_Term = $Parent_Term;
			$new_Parent_Term =~ s/_/ /g;
			print PAPER "$Study_Accession\t$new_Disease_Trait\t$new_EFO_Term\t$new_Parent_Term\t$Gene\t$Unique_ID\t$ancestry\n";
		}
	}
	close(INFO);
}
