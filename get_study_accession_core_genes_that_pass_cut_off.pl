#!/usr/bin/perl

my %mapped_hash = ();
my %convert_to_gene = ();
my %convert_to_study_accession = ();
my %study_accession_hash = ();

my $file_out = "STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt";
open(OUT, ">$file_out");

print OUT "study_accession\tdisease_trait\tcore_gene\tp_value\traw_p_value\ttype\n";

&make_study_accession_hash;
&convert_ppi_name;
&loop_through_study_accession_files;

close(OUT);

sub loop_through_study_accession_files
{
	foreach my $file (`ls *study_accession_raw_p_values.txt_reformatted_for_R.txt_BH_corrected.txt_sorted.txt`)
	{
		chomp($file);
		&get_significant_core_genes($file);
	}
}

sub get_significant_core_genes
{
	my $file_in = shift;
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($adjusted_p_value, $raw_p_value, $ppi_name) = split(/\s+/,$_);
		if($adjusted_p_value <= 0.05)
		{
			if((exists $convert_to_gene{$ppi_name})&&(exists $convert_to_study_accession{$ppi_name}))
			{
				my $core_gene = $convert_to_gene{$ppi_name};
				my ($study_accession, $disease_trait) = split(/\t/,$convert_to_study_accession{$ppi_name},2);
				if(exists $mapped_hash{$study_accession}{$core_gene})
				{	
					print OUT "$convert_to_study_accession{$ppi_name}\t$core_gene\t$adjusted_p_value\t$raw_p_value\tPPI-GWAS\n";
				}
				else
				{
					print OUT "$convert_to_study_accession{$ppi_name}\t$core_gene\t$adjusted_p_value\t$raw_p_value\tPPI_ONLY\n";
				}
			}
		}
	}
	close(INFO);
} 

sub make_study_accession_hash
{
	my $file_in = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $efo_term, $parent_term, $gene, $unique_id) = split(/\t/,$_);
		if(!($study_accession eq "study_accession"))
		{
			$mapped_hash{$study_accession}{$gene} = $gene;
			$study_accession_hash{$study_accession} = $study_accession."\t".$disease_trait;
		}
	}
	close(INFO);
}


sub convert_ppi_name
{
	my $file_in = "FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		foreach my $study_accession (keys %study_accession_hash)
		{
			my $ppi_name = $study_accession."_".$_."_ppi_family";
			$convert_to_gene{$ppi_name} = $_;
			$convert_to_study_accession{$ppi_name} = $study_accession_hash{$study_accession};
		}
	}
	close(INFO);
}
