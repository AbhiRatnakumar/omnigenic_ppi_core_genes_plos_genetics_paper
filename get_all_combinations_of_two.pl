#!/usr/bin/perl

my %hash = ();
my %chr_hash = ();

my $file_out = "GWAS_HITS_WITHIN_1MB_OF_EACH_OTHER.txt";
open(OUT, ">$file_out");

&store_coords;
&get_core_genes_detected_by_only_2_GWAS_hits;

close(OUT);

sub get_core_genes_detected_by_only_2_GWAS_hits
{
	my $file_in = "BH_CORRECTED_CORE_GENES_for_all_GWAS_studies_annotated_with_270_studies_GENES_TAGGED_UNTAGGED.txt";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;
		my ($study_accession, $disease_trait, $core_gene, $gwas_list, $junk) = split(/\t/,$_,5);
		my @cols1 = split(/,/,$gwas_list);
		my @cols2 = split(/,/,$gwas_list);
		for(my $x = 0; $x<@cols1; $x++)
		{
			for(my $y = 0; $y<@cols2; $y++)		
			{
				if(!($cols1[$x] eq $cols2[$y]))
				{
					&get_distance($core_gene,$cols1[$x],$cols2[$y]);	
				}
			}	
		}
	}
	close(INFO);
}


sub get_distance
{
	my $core_gene = shift;
	my $gwas_hit1 = shift;
	my $gwas_hit2 = shift;
        if((exists $chr_hash{$gwas_hit1})&&(exists $chr_hash{$gwas_hit2}))
       	{
        	my $chr1 = $chr_hash{$gwas_hit1};
                my $chr2 = $chr_hash{$gwas_hit2};
                if($chr1 == $chr2)
                {
                	my ($chr_1, $start_1, $end_1, $gene_1) = split(/\t/,$hash{$gwas_hit1});
                        my ($chr_2, $start_2, $end_2, $gene_2) = split(/\t/,$hash{$gwas_hit2});
                      	if(($start_1 - $end_2) < 1000000 )
                       	{
                       		my $diff = $start_1 - $end_2;
                               	if($diff > 0)
                               	{
                                	print OUT "$diff\t$core_gene\t$gwas_hit1\t$gwas_hit2\n";
                                }
                      	}
                       	elsif(($start_2 - $end_1) < 1000000 )
                      	{
                       		my $diff = $start_2 - $end_1;
                              	if($diff > 0)
                              	{
                               		print OUT "$diff\t$core_gene\t$gwas_hit1\t$gwas_hit2\n";
				}
                      	}
                      	elsif(($end_2 - $start_1) < 1000000 )
                      	{
                        	my $diff = $end_2 - $start_1;
                              	if($diff > 0)
                              	{
                           		print OUT "$diff\t$core_gene\t$gwas_hit1\t$gwas_hit2\n";
				}
                   	}
                       	elsif(($end_1 - $start_2) < 1000000 )
                     	{
                       		my $diff = $end_1 - $start_2;
                              	if($diff > 0)
                              	{
                              		print OUT "$diff\t$core_gene\t$gwas_hit1\t$gwas_hit2\n";
				}
                    	}
       		}
   	}
}


sub store_coords
{
	my $file_in = "genes_from_mart_export_grch37_converted_to_bed_SORTED.bed_only_11049_genes.bed";
	open(INFO, $file_in);

	while(<INFO>)
	{
		chomp;	
		my ($chr, $start, $end, $gene) = split(/\t/,$_);
		$chr_hash{$gene} = $chr;
		$hash{$gene} = $_;
	}
	close(INFO);	
}

