#!/usr/bin/perl


my %study_accessions_hash = ();

&get_a_list_of_all_the_study_accessions;
&split_the_file_by_study_accession;
&reformat_files_for_R;

# make a hash called study_accessions_hash, with the study accession as the key and the study accession as the value
sub get_a_list_of_all_the_study_accessions
{
	my $file_in = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my($study_accession, $disease_trait, $efo_term, $parent_term, $gene, $unique_id) = split(/\t/,$_);
		if(!($study_accession eq "study_accession"))
		{
			$study_accessions_hash{$study_accession} = $study_accession;	
		}
	}
	close(INFO);
}

# after making a hash of all of the study accessions, then loop through the study accessions
# for each study accession 
# make an awk command that extracts thge study accession from the file
# merged_dhyper_output_all_studies, the outtput file is study_accession_raw_p_values.txt
# the output file has the suffix study_accession_raw_p_values.txt
# this makes sense because the file merged_dhyper_output_all_studies, contains the output from all of the input file, which contaisn the overlaps
# if the overlap is 1 or more
sub split_the_file_by_study_accession
{
	foreach my $study_accession (keys %study_accessions_hash)
	{
		chomp;
		my $cmd = "awk \'/$study_accession/\' merged_dhyper_output_all_studies.txt > $study_accession\"_study_accession_raw_p_values.txt\""; 
		system($cmd);
	}
}

# After extracting out the study_accession
# Then raw output file contains all these weird spaces from the running stuff in R
# So I need to convert the spaces into tabs
sub reformat_file
{
	my $file_in = shift;
	open(INFO, $file_in);

	my $file_out = $file_in."_reformatted_for_R.txt";
	open(OUT, ">$file_out");

	print OUT "p_value\tppi_family\n";
	while(<INFO>)
	{
		chomp;
		my ($raw_p_value, $ppi_family, $junk) =split(/\s+/,$_,3);
		print OUT "$raw_p_value\t$ppi_family\n";
	}
	close(INFO);
	close(OUT);
}


# Then loop through all of the files and reformat them
# by looping the files with suffix *_study_accession_raw_p_values.txt
sub reformat_files_for_R
{
	foreach my $file (`ls *_study_accession_raw_p_values.txt`)
	{
		chomp($file);
		&reformat_file($file);
	}
}
