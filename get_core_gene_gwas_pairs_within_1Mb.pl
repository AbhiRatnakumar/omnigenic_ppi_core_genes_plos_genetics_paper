#!/usr/bin/perl


my %remove_hash = ();
my %tagged_hash = ();

&make_tagged_hash;
&get_within_1MB;
&remove_it;
&make_tagged_untagged;


sub make_tagged_untagged
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies.txt";
        open(INFO, $file_in);

	my $file_out = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED.txt";
	open(OUT, ">$file_out");

        while(<INFO>)
        {       
                chomp;
                my ($study_accession, $junk, $core_gene, $gwas_list, $junk1) = split(/\t/,$_,5);
                my $ppi_name = $study_accession."_".$core_gene."_ppi_family";
		if(exists  $tagged_hash{$ppi_name})
		{
			print OUT "$_\tPPI-GWAS\n";
		}
		else
		{
			print OUT "$_\tPPI_only\n";
		}
	}
	close(INFO);
	close(OUT);
}


sub remove_it
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $junk, $core_gene, $gwas_list, $junk1) = split(/\t/,$_,5);
		my $ppi_name = $study_accession."_".$core_gene."_ppi_family";
		my @cols = split(/,/,$gwas_list);
		for(my $i=0; $i<@cols; $i++)
		{
			if(exists $remove_hash{$ppi_name}{$cols[$i]})
			{
				$tagged_hash{$ppi_name} = $ppi_name;	
			}
		}
	}
	close(INFO);
}

sub make_tagged_hash
{
	my $file_in = "MERGED_GENE_LIST_for_each_DISEASE_ID_for_paper.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
                my ($Study_Accession, $Disease_Trait, $EFO_Term, $Parent_Term, $Gene, $Unique_ID, $Ancestry) = split(/\t/,$_);
		my $ppi_name = $Study_Accession."_".$Gene."_ppi_family";
		$tagged_hash{$ppi_name} = $ppi_name;
	}
	close(INFO);
}


sub get_within_1MB
{
	my $file_in = "SAME_CHROMOSOME_ANNOTATED_WITH_DIFFERENCE_Distance_bw_core_genes_and_the_gwas_hits_the_core_genes_were_detected_from.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($difference, $id1, $id2) = split(/\t/,$_);
		if($difference < 1000001)
		{
			my ($last) = (split(/_/, $id2))[-1];
			$remove_hash{$id1}{$last} = $last;
		}
	}
	close(INFO);
}
