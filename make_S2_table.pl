#!/usr/bin/perl

my %done = ();
my %has_core_gene = ();
my %has_excess_PPI_edges = ();

&make_excess_ppi_edges_hash;
&make_has_core_gene_hash;
&annotate_S1;

sub annotate_S1
{
	my $file_in = "MERGED_GENE_LIST_for_each_DISEASE_ID_for_paper.txt";
	open(INFO, $file_in);

	my $file_out = "S2_Table.txt";
	open(OUT, ">$file_out");

	my $line = "";
	while(<INFO>)
	{
		chomp;
		my ($Study_Accession, $Disease_Trait, $EFO_Term, $Parent_Term, $Gene, $Unique_ID, $Ancestry) = split(/\t/,$_);
		if($Study_Accession =~ /Accession/)
		{
			$line= "$Study_Accession\t$Disease_Trait\t$Parent_Term\tGWAS Hit\tSNP_ID\t$Ancestry\tExcess PPI edges\tDetected Core Gene";
		}
		elsif((exists $has_excess_PPI_edges{$Study_Accession})&&(exists $has_core_gene{$Study_Accession}))
		{
			$line =  "$Study_Accession\t$Disease_Trait\t$Parent_Term\t"."\"$Gene\""."\t$Unique_ID\t$Ancestry\thas excess PPI edges\tdetected Core Gene";
		}
		elsif(exists $has_excess_PPI_edges{$Study_Accession})
		{
			$line = "$Study_Accession\t$Disease_Trait\t$Parent_Term\t"."\"$Gene\""."\t$Unique_ID\t$Ancestry\thas excess PPI edges\t";
		}
		elsif(exists $has_core_gene{$Study_Accession})
		{
			$line = "$Study_Accession\t$Disease_Trait\t$Parent_Term\t"."\"$Gene\""."\t$Unique_ID\t$Ancestry\t\tdetected Core Gene";
		}
		else
		{
			$line= "$Study_Accession\t$Disease_Trait\t$Parent_Term\t"."\"$Gene\""."\t$Unique_ID\t$Ancestry\t\t";
		}
		if(!exists $done{$line})
		{
			print OUT "$line\n";
		}
		$done{$line} = $line;
	}
	close(INFO);
	close(OUT);
}




sub make_has_core_gene_hash
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED_filter_out_GWAS_HITS_that_are_within_1_Mb.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $junk1, $junk2, $junk3, $junk4, $junk5, $junk6, $excess_ppi_edges, $tagged_vs_untagged) = split(/\t/,$_);
		$has_core_gene{$study_accession} = $study_accession;
	}
	close(INFO);
}


sub make_excess_ppi_edges_hash
{
        my $file_in = "Studies_with_excess_PPI_edges.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
                my ($input_study_accession, $observed_number_of_edges, $count_random, $fdr) = split(/\t/,$_);
                if(!($input_study_accession =~ /input/))
                {
                        $has_excess_PPI_edges{$input_study_accession} = $input_study_accession;
                }
        }
        close(INFO);
}

