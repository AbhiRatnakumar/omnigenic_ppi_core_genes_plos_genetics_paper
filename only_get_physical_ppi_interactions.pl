#!/usr/bin/perl

my %map_hash = ();
my %ppi_counts_hash = ();
my %ens_hash = ();
my %syn_hash = ();
my %binding_hash = ();
my %hash = ();
my %check_hash = ();
my %exclude_hash = ();

# The first step is to read in the gene name file 
&read_in_gene_name_file;
&make_ens_protein_hgnc_hash;
&convert_string_ppi;
&filter_for_binding;
&print_out_final_list;
&count_the_elements_in_the_ppi_family;

sub count_the_elements_in_the_ppi_family
{
        my $file_out = "String_PPI_hgnc_converted_score_gt_700_only_binding_PPI_COUNTS.txt";
        open(OUT, ">$file_out");

	print OUT "ppi_name\tcount\n";

        foreach my $ppi_family ( keys %ppi_counts_hash )
        {
                my $count = 0;
                for my $protein ( keys %{ $ppi_counts_hash{$ppi_family} } )
                {
                        $count++;
                }
                print OUT "$ppi_family\t$count\n";
        }
        close(OUT);
}


sub filter_for_binding
{
        my $file_in = "9606.protein.links.v10.5.txt";
        open(INFO, $file_in);
        my $file_out = "String_PPI_hgnc_converted_score_gt_700_only_binding.txt";
        open(OUT, ">$file_out");
        my ($protein1_hgnc_symbol, $protein2_hgnc_symbol);
        while(<INFO>)
        {
                chomp;
		my ($protein1_hgnc_symbol, $protein2_hgnc_symbol);
                my ($protein1, $protein2, $score) = split(/\s+/,$_);
                if($score >= 700)
                {
                        if((exists $hash{$protein1})&&(exists $hash{$protein2}))
                        {
                                $protein1_hgnc_symbol = $hash{$protein1};
                                $protein2_hgnc_symbol = $hash{$protein2};
                        	
				if(($protein1_hgnc_symbol)&&($protein2_hgnc_symbol))
                        	{
					if((!exists $exclude_hash{$protein1_hgnc_symbol})&&(!exists $exclude_hash{$protein2_hgnc_symbol}))
                                	{
						if(!($protein1_hgnc_symbol eq $protein2_hgnc_symbol))
                                		{
							if($protein1_hgnc_symbol < $protein2_hgnc_symbol)
							{
								if(exists $binding_hash{$protein1_hgnc_symbol}{$protein2_hgnc_symbol})
								{
									print OUT "$protein1_hgnc_symbol"."_ppi_family\t$protein1_hgnc_symbol\t$protein2_hgnc_symbol\t$score\n";
	                                                       		my $ppi_family = $protein1_hgnc_symbol."_ppi_family";
        	                                                	$ppi_counts_hash{$ppi_family}{$protein2_hgnc_symbol} = $protein2_hgnc_symbol;
                	                                        	$keep_hash{$protein1_hgnc_symbol} = $protein1_hgnc_symbol;
								}
							}
							else
							{
								if(exists $binding_hash{$protein2_hgnc_symbol}{$protein1_hgnc_symbol})
                                                        	{
                                                                	print OUT "$protein2_hgnc_symbol"."_ppi_family\t$protein2_hgnc_symbol\t$protein1_hgnc_symbol\t$score\n";
                                                                	my $ppi_family = $protein2_hgnc_symbol."_ppi_family";
                                                                	$ppi_counts_hash{$ppi_family}{$protein1_hgnc_symbol} = $protein1_hgnc_symbol;
                                                                	$keep_hash{$protein2_hgnc_symbol} = $protein2_hgnc_symbol;
                                                        	}

							}
						}
                                	}
                        	}	
                	}
			else
			{
				#print "ppi_not_in_hash\t$_\n";
			}
        	}
	}
        close(INFO);
}

sub print_out_final_list
{
        my $file_out = "FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt";
        open(OUT, ">$file_out");

        foreach my $key (keys %keep_hash)
        {
                print OUT "$key\n";
        }
        close(OUT);
}

sub convert_string_ppi
{
        my $file_in = "9606.protein.actions.v10.5.txt";
        open(INFO, $file_in);

        my ($protein1_hgnc_symbol, $protein2_hgnc_symbol);
        my ($item_id_a, $item_id_b, $mode, $action, $is_directional, $a_is_acting, $score);
        while(<INFO>)
        {
                chomp;
                my ($protein1_hgnc_symbol, $protein2_hgnc_symbol);
		my ($protein1, $protein2, $mode, $action, $is_directional, $a_is_acting, $score) = split(/\t/,$_);
                if($mode =~ /binding/)
                {
                        if((exists $hash{$protein1})&&(exists $hash{$protein2}))
                        {
                                $protein1_hgnc_symbol = $hash{$protein1};
                                $protein2_hgnc_symbol = $hash{$protein2};
                        	if(($protein1_hgnc_symbol)&&($protein2_hgnc_symbol))
                        	{
                                	if(!($protein1_hgnc_symbol eq $protein2_hgnc_symbol))
                                	{
						if($protein1_hgnc_symbol < $protein2_hgnc_symbol)
						{
							$binding_hash{$protein1_hgnc_symbol}{$protein2_hgnc_symbol} = $protein1_hgnc_symbol;
                                        	}
						else
						{
							$binding_hash{$protein2_hgnc_symbol}{$protein1_hgnc_symbol} = $protein2_hgnc_symbol;
                                		}
					}
                        	}
                	}
		}
        }
        close(INFO);
}

# after reading in the info about the approved hgnc symbols
# the next step is to read in the list of aliases for the proteins in String network
# the format of the protein aliases file (1) string protein id (2) alias (3) source
sub make_ens_protein_hgnc_hash
{
        my $file_in = "protein.aliases.v10.5.txt";
        open(INFO, $file_in);

	my $file_exclude = "proteins_to_EXCLUDE.txt";
	open(EXCLUDE, ">$file_exclude");

        while(<INFO>)
        {
                chomp;
                my ($ens_protein_id, $hgnc_id, $type) = split(/\t/,$_,3);
                if(($type =~ /Ensembl_HGNC_HGNC_ID/)||($hgnc_id =~ /HGNC:/))
                {
                        # extract out the approved symbol for teh hgnc id
			if(exists $map_hash{$hgnc_id})
                        {
				# store everything in a hash with the protein id as the key
				# if there is a discrepany between the approved symbol from trhe hgnc id or obne that is alreday in the
				# the hash then exclude that and store it in eckude hash 
				if(!exists($hash{$ens_protein_id}))
				{
					$hash{$ens_protein_id} = $map_hash{$hgnc_id};
				}
				elsif(!($map_hash{$hgnc_id} eq $hash{$ens_protein_id}))
				{
					print EXCLUDE "already exsists $ens_protein_id,$hash{$ens_protein_id},$map_hash{$hgnc_id},\n";
					$exclude_hash{$hash{$ens_protein_id}} = $hash{$ens_protein_id};
					$exclude_hash{$map_hash{$hgnc_id}} = $map_hash{$hgnc_id};

				}
			}
                }
		if($hgnc_id =~ /ENSG/)
		{
			if(exists $ens_hash{$hgnc_id})
			{
				if(!exists($hash{$ens_protein_id}))
                		{
					$hash{$ens_protein_id} = $ens_hash{$hgnc_id};
				}
				elsif(!($ens_hash{$hgnc_id} eq $hash{$ens_protein_id}))
                                {
					print EXCLUDE "ens already exsists $ens_protein_id,$hash{$ens_protein_id},$ens_hash{$hgnc_id},\n";
					$exclude_hash{$ens_hash{$hgnc_id}} = $ens_hash{$hgnc_id};
                                        $exclude_hash{$hash{$ens_protein_id}} = $hash{$ens_protein_id};
				}
			}
		}
        }
        close(INFO);
	close(EXCLUDE);
}

# read in the file that contains all of the information about the hgnc protein products
# we make a hash called map_hash that contains the hgnc id and the corresponding hgnc symbol
# another hash called ens hash which contains the ensembl gene id and teh approved hgnc symbok
# and another hash called syn_hash, which contains synonyms of the hgnc symbol in the key and the approved hgnc symbol
# as the value
sub read_in_gene_name_file
{
	my $file_in = "gene_with_protein_product.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my @cols = split(/\t/,$_);
		
		my $hgnc_id = $cols[0];
		my $symbol = $cols[1];
		my $alias_symbol = $cols[8];
		my $prev_symbol = $cols[10];
		my $ensembl_gene_id = $cols[19]; 
				
		$alias_symbol =~ s/^"(.*)"$/$1/; 
		$prev_symbol =~ s/^"(.*)"$/$1/; 
	
		$map_hash{$hgnc_id} = $symbol;
		$ens_hash{$ensembl_gene_id} = $symbol;
		$check_hash{$symbol} = $symbol;
	
		if($alias_symbol =~  /\|/)
		{
			my @alias_arr = split(/\|/,$alias_symbol);
			for(my $i=0; $i<@alias_arr; $i++)
			{
				$syn_hash{$alias_arr[$i]} = $symbol;
			}	
		}
		elsif($alias_symbol)
		{
			$syn_hash{$alias_symbol} = $symbol;
		}
		if($prev_symbol =~  /\|/)
                {
                        my @prev_arr = split(/\|/,$prev_symbol);
                        for(my $i=0; $i<@prev_arr; $i++)
                        {
                        	$syn_hash{$prev_arr[$i]} = $symbol;
			}
                }
		elsif($prev_symbol)
		{
			$syn_hash{$prev_symbol} = $symbol;
		}		
	}
	close(INFO);
} 
