#!/usr/bin/perl

my $file_out = "HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies.txt";
open(OUT, ">>$file_out");

my $line_count = 1;

my %ppi_fam_count = ();
my %total_no_loci = ();
my %check_hash = ();
my %ppi_hash = ();
my %hgnc_hash = ();
my %gene_pathway_hash = ();
my %all_cases_hash = ();
my %list_of_all_disease_set_ids = ();

my $TOP_LIST_COUNT = 0;
my $ALL_LIST_COUNT = 0;

#general
&store_the_total_number_of_loci_per_disease_study;
&make_ppi_string_count_hash;
&make_ppi_fam_hash;
&make_all_cases_hash;
&make_gene_family_hash;

&read_in_all_diseases;
&read_in_each_disease;
&loop_through_all_disease_sets;

# The first step is to read in the file that has each disease id plus ppi node family to each disease id
# The value within teh hash is the count of the number of protein nodes within the ppi_fam_count hash 
sub make_ppi_string_count_hash
{
	my $file_in = "PPI_COUNTS_GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($id, $count) = split(/\t/,$_);
		$ppi_fam_count{$id} = $count;
	}
	close(INFO);
}



#The next step is to loop through all of the disease ids, then for each disease id we call the routine
# make_pathways_hash
sub loop_through_all_disease_sets
{
	$TOP_LIST_COUNT = 0;
	foreach my $disease_set (keys %list_of_all_disease_set_ids)
	{
		if(!($disease_set =~ /study_accession/))
		{
			#print "doing disease $disease_set\n";
			&make_pathways_hash($disease_set);
		}
	}
}

# The next step is to read in all of the diseases which we store in the hash list_of_all_disease_set_ideas 
sub read_in_all_diseases
{
	my $file_in = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in);
	
	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $junk) = split(/\t/,$_,3);
		
		if(!($study_accession =~ /pubmedid/))
		{
			$list_of_all_disease_set_ids{$study_accession} = $disease_trait;
		}
	}
	close(INFO);
}

# The next step is to read in all of the genes for each disease id
# we store it in a hash called cases_lt_75_hash, the first key is teh disease id the second key is the gene
# we make sure the gene is in our list of 10,996 genes
sub read_in_each_disease
{
	# per disease
	$TOP_LIST_COUNT = 0;
	%cases_lt_75_hash = ();	

	my $file_in = "GENE_LIST_for_each_DISEASE_ID.txt";
	open(INFO, $file_in); 
	
	while(<INFO>)
	{
		chomp;
		my ($id, $disease_trait, $efo_term, $parent_term, $gene, $loci_id) = split(/\t/,$_);
		if(exists $hgnc_hash{$gene})
		{
			$cases_lt_75_hash{$id}{$gene} = $loci_id;
		}
	}
	close(INFO);
}

# This routine reads in the disease id which is passed in , then it checks if this disease id is in the hash
# cases_lt_75_hash, and it counts the number of genes per disease id
# Then count the number of genes within the disease id
# it stores this count in the variable TOP_LIST_COUNT
sub count_top_list_count
{
	my $disease_set = shift;
	my $count_gene = 0;
	$TOP_LIST_COUNT = 0;
	if(exists $cases_lt_75_hash{$disease_set})
	{
		for my $count_gene ( keys %{ $cases_lt_75_hash{$disease_set} } )
                {
			$TOP_LIST_COUNT++;	
		}
	}
}

# The next step is to read in the PPI network, with the ppi_name, first, then the hub, then the gene, then the score
# then store this in a hash called gene_pathway_hash with the first key the ppi node name and teh second key the gene name
# so this is a way of storing all teh genes connected to the ppi node
sub make_gene_family_hash
{
       	my $file_in = "String_PPI_hgnc_converted_score_gt_700_only_binding.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
                my($pathway_name,$hub, $gene, $junk)= split(/\t/,$_);
                if($pathway_name)
                {
			if((exists $ppi_hash{$pathway_name})&&(exists $hgnc_hash{$gene}))
			{
                        	$gene_pathway_hash{$pathway_name}{$gene} = $pathway_name;
			}
		}
        }
        close(INFO);
}

#convert ppi fam name to just the gene name
# the next step is to make a hash that enables teh conversion of the ppi name to teh just the gene name
sub make_ppi_fam_hash
{
        my $file_in = "FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
                my $ppi_name = $_."_ppi_family";
                $ppi_hash{$ppi_name} = $_;
               	$hgnc_hash{$_} = $_;
        }
        close(INFO);
}

# This routine inititalises the TOP_list_count to 0 
# it reads in the disease id as teh one that is passed in 
# then it counts the number of genes in each disease is by callimng the routin count_top_list
# after it gets the count of the number of gwas gene for each disease
# Then it loops through the gene pathway hash which has the ppi node and the first key and the has the gene as the second key
# it goes throygh all the genes in each ppi node and then checks to see if that gene is in the top genes list, if it then incremenet cases_lt_75
# then count the total number of genes within the ppi node
sub make_pathways_hash
{
	$TOP_LIST_COUNT = 0;
	my $disease_set = shift;
	&count_top_list_count($disease_set);
	foreach my $pathway ( keys %gene_pathway_hash ) 
	{
		my $cases_lt_75_count = 0;
		my $all_cases_count = 0;  
   		my $line = "";
   		my $loci_line = "";
		my %done_loci = ();
		my $count_unique_loci = 0;
		for my $gene ( keys %{ $gene_pathway_hash{$pathway} } ) 
		{
			my $new_gene = $gene;
			if(exists $cases_lt_75_hash{$disease_set}{$new_gene})
			{
				my $loci_id = $cases_lt_75_hash{$disease_set}{$new_gene};
				if(!$line)
				{
					$line = $new_gene;
				}
				else
				{
					$line = $line.",".$new_gene;
				}
				if(!exists $done_loci{$loci_id})
				{
					if(!$loci_line)
                                	{
                                        	$loci_line = $loci_id;
					}
                                	else
                                	{
                                        	$loci_line = $loci_line.",".$loci_id;
                                	}
					$count_unique_loci++;
				}	
				$done_loci{$loci_id} = $loci_id;				
				$cases_lt_75_count++;
			}
			if(exists $all_cases_hash{$new_gene})
                        {
                                $all_cases_count++;
			}
		}
		if(exists $total_no_loci{$disease_set})
		{
			my $check_pathway_id = $disease_set."_".$pathway;
			my $count_of_loci =  $total_no_loci{$disease_set};
			$check_hash{$check_pathway_id} = $line."\t".$loci_line."\t".$count_unique_loci."\t".$count_of_loci;	
		}	
		# Check that there is at least one gene in the ppi node family 
		# if the number of top gwas hits is greater than 0 than make a pathway_id which has teh disease is and the ppi ndoe name
		# this is a way to store the disease and ppi node info in 1 id, then print out line count , pathwya id, the number of gwas hits genes, the number of 
		# proteins in the proetin complex and the number of proteins within the protein complex that are also gwas hits 	
		if(($all_cases_count)||($cases_lt_75_count))
		{
			if($cases_lt_75_count > 0)
			{
				my $pathway_id = $disease_set."_".$pathway;
				if(exists $ppi_fam_count{$pathway_id})
				{
					if(exists $check_hash{$pathway_id})
					{
						print OUT "$line_count\t$pathway_id\t$TOP_LIST_COUNT\t$ppi_fam_count{$pathway_id}\t$cases_lt_75_count\t$check_hash{$pathway_id}\n";
					
					}
					else
					{
						print "$disease_set\t$line_count\t$pathway_id\tnot-there\n";
					}	
					$line_count++;
				}
			}
			else
			{
				#print "missing-ignore\t$disease_set\t$pathway\n";		
			}
		}
	}
}



sub store_the_total_number_of_loci_per_disease_study
{
	my $file_in = "NUMBER_of_GWAS_LOCI_PER_DISEASE.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my($study, $no_of_loci) = split(/\t/,$_);
		$total_no_loci{$study} = $no_of_loci;
	}
	close(INFO);
}

# The next step is to get a list of all the proteins, which is waht we will use to compare the top hits against
# This is stored in the hash all_cases_hash, and we count the number of genes within this list : ALL_LIST_COUNT, 10,996
sub make_all_cases_hash
{
       	my $file_in = "FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt";
        open(INFO, $file_in);

        while(<INFO>)
        {
                chomp;
		my $pathway = $_;
		$all_cases_hash{$pathway} =$pathway;
		$ALL_LIST_COUNT++;
	}
        close(INFO);
}
