#!/usr/bin/perl

my %hash = ();
my %efo_disease_hash = ();
my %efo_hash = ();
my %count_parent_terms = ();
my %contains_other = ();
my %parent_term_list =();
my %store_lines = ();
my %other_hash = ();
my %done = ();
my %just_for_checking_hash = ();

&make_hash_of_disease_terms;
&add_parent_terms_to_file;
&add_efo_terms_to_file;
&get_exactly_two;
&loop_through_and_print;

# Get all lines removed from step 7
my $file_removed_PARENT_TERM_LINES = "REMOVED_LINES_due_to_PARENT_TERM_QC.txt";
open(removed_PARENT_TERM_LINES, ">$file_removed_PARENT_TERM_LINES");

print removed_PARENT_TERM_LINES "study_accession\tdisease_trait\tparent_term\n";

&make_hash_of_check7;
&get_removed_lines;

close(removed_PARENT_TERM_LINES);


sub loop_through_and_print
{
	my $file_out = "check7.txt";
        open(OUT, ">$file_out");

	foreach my $study_accession ( keys %store_lines ) 
	{
     		for my $line ( keys %{ $store_lines{$study_accession} } ) 
		{
			if(exists $other_hash{$study_accession})
			{
				if(exists $parent_term_list{$study_accession})
				{
					my $parent_term = $parent_term_list{$study_accession};
					if(exists $efo_hash{$study_accession})
                			{
                        			for my $efo_term ( keys %{ $efo_hash{$study_accession} } )
                        			{
                                			print OUT "$line\t$efo_term\t$parent_term\n";
                        			}
                			}
					$done{$study_accession} = $study_accession;
				}
			}
		}
 	}
	foreach my $study_accession ( keys %store_lines )
        {
                for my $line ( keys %{ $store_lines{$study_accession} } )
                {
                        my $parent_term = $store_lines{$study_accession}{$line};

                        if(!exists $done{$study_accession})
                        {
				if($count_parent_terms{$study_accession} ==1)
				{
                        		if(exists $efo_hash{$study_accession})
                                        {
                                                for my $efo_term ( keys %{ $efo_hash{$study_accession} } )
                                                {
                                                        print OUT "$line\t$efo_term\t$parent_term\n";
                                                }
                                        } 
				}
			}
                }
        }	
	close(OUT);
}




sub add_efo_terms_to_file
{
        my $file_in = "check6.txt";
        open(INFO, $file_in);

        my $file_out = "temp_EFO_check6.txt";
        open(OUT, ">$file_out");

        my %temp_count_parent_terms =();
        my %temp_parent_term_list =();

        while(<INFO>)
        {
                chomp;
                my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
                if(!($unique_id eq "unique_id"))
                {
                        if(exists $efo_disease_hash{$disease_trait})
                        {
                                for my $efo_term ( keys %{ $efo_disease_hash{$disease_trait} } )
                                {
                                        print OUT "$study_accession\t$disease_trait\t$efo_term\n";
                                	$efo_hash{$study_accession}{$efo_term} = $efo_term;
				}
			}
		}
	}
	close(INFO);
	close(OUT);
} 





sub add_parent_terms_to_file
{
        my $file_in = "check6.txt";
        open(INFO, $file_in);

        my $file_out = "temp_check6.txt";
        open(OUT, ">$file_out");

	my %temp_count_parent_terms =();
	my %temp_parent_term_list =();

        while(<INFO>)
        {
                chomp;
                my ($study_accession, $unique_id, $loci_id, $publication_id, $disease_trait, $p_value, $odds_ratio, $beta_coefficient, $gene, $snp_platform, $ancestry) = split(/\t/,$_);
                if(!($unique_id eq "unique_id"))
                {
                        if(exists $hash{$disease_trait})
                        {
                                for my $parent_term ( keys %{ $hash{$disease_trait} } )
                                {
					print OUT "$study_accession\t$disease_trait\t$parent_term\n";
					$store_lines{$study_accession}{$_} = $parent_term;
					$temp_count_parent_terms{$study_accession}{$parent_term} = $parent_term;
					if($parent_term =~ /^Other/)
					{
						$contains_other{$study_accession} = $study_accession;
					}
					$temp_parent_term_list{$study_accession}{$parent_term} = $parent_term;
				}
			}
		}
	}
	close(INFO);
	close(OUT);
	foreach my $study_accession ( keys %temp_count_parent_terms )
        {
                for my $parent_term ( keys %{ $temp_count_parent_terms{$study_accession} } )
                {	
			$count_parent_terms{$study_accession}++;
		}
	}

	foreach my $study_accession ( keys %temp_parent_term_list )
        {
                for my $parent_term ( keys %{ $temp_parent_term_list{$study_accession} } )
                {
			if(!($parent_term =~ /^Other/))
			{
                		if(!exists $parent_term_list{$study_accession})
				{	
					$parent_term_list{$study_accession} = $parent_term;
				}
				else
				{
					$parent_term_list{$study_accession} = $parent_term_list{$study_accession}.",".$parent_term;
				}
			}
		}
        }
	foreach my $study_accession (keys %parent_term_list)
	{
		#print "$study_accession\t$parent_term_list{$study_accession}\n";
	}
}


sub get_exactly_two
{
	foreach my $study_accession (keys %count_parent_terms)
	{
		if(($count_parent_terms{$study_accession} == 2)&&(exists $contains_other{$study_accession}))
		{
			if(exists $parent_term_list{$study_accession})
			{
				#print "$study_accession\t$parent_term_list{$study_accession}\n";
				$other_hash{$study_accession} = $parent_term_list{$study_accession};
				#print "$study_accession\t$parent_term_list{$study_accession}\n";
			}	
		}
	}	
}


# Read in the file, that contains the disease trait, the efo term, the efo uri, the parent term and parent uri
# make a hash that contains the disease trait as the key and the EFO term and the parent term as the value
sub make_hash_of_disease_terms
{
	my $file_in = "gwas-efo-trait-mappings.tsv";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($Disease_trait, $EFO_term, $EFO_URI, $Parent_term, $Parent_URI) = split(/\t/,$_);
		if(($EFO_term)&&($Parent_term))
		{
			my $line = $EFO_term."\t".$Parent_term;
			$hash{$Disease_trait}{$Parent_term} = $Parent_term;
			$efo_disease_hash{$Disease_trait}{$EFO_term} = $EFO_term;
		}
	}
	close(INFO);
	close(OUT);
}
#!/usr/bin/perl

my %just_for_checking_hash = ();

# Get all lines removed from step 7

my $file_removed_PARENT_TERM_LINES = "REMOVED_LINES_due_to_PARENT_TERM_QC.txt";
open(removed_PARENT_TERM_LINES, ">$file_removed_PARENT_TERM_LINES");

print removed_PARENT_TERM_LINES "study_accession\tdisease_trait\tparent_term\n";

&make_hash_of_check7;
&get_removed_lines;

close(removed_PARENT_TERM_LINES);


sub get_removed_lines
{
	my $file_temp2 = "temp_check6.txt";
	open(TEMP2, $file_temp2);

	while(<TEMP2>)
	{
		chomp;
		my ($study_accession, $disease_trait, $parent_term) = split(/\t/,$_,3);
		if(!(exists $just_for_checking_hash{$study_accession}))
		{
			print removed_PARENT_TERM_LINES "$_\n";	
		}
	} 
	close(TEMP2);
}


sub make_hash_of_check7
{
	my $file_temp1 = "check7.txt";
	open(TEMP1, $file_temp1);

	while(<TEMP1>)
	{
		chomp;
		my ($study_accession, $rest_of_the_line) = split(/\t/,$_,2);
		$just_for_checking_hash{$study_accession} = $rest_of_the_line;
	}
	close(TEMP1);
}
