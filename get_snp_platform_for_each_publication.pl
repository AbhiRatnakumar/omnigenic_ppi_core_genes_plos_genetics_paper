#!/usr/bin/perl

my %done = ();


my $file_snp_platform = "SNP_platform_for_each_publication.txt";
open(SNP_PLATFORM, ">$file_snp_platform");


&loop_thru_gwas_catalog;

close(SNP_PLATFORM);

sub loop_thru_gwas_catalog
{
	my $file_in = "gwas_catalog_v1.0.2-associations_e93_r2018-08-28.tsv";
	open(INFO, $file_in);

	# the unique identifier, is the pubmed id, the disease/trait, the strongest snp risk allele
	# cols, 2, 8, 21 and
	while(<INFO>)
	{
		chomp;
		my @cols = split(/\t/,$_);
		my $pubmed_id = $cols[1];
		my $snp_platform = $cols[32];
		if(!exists $done{$_})
		{
			print SNP_PLATFORM "$pubmed_id\t$snp_platform\n";
		}
		$done{$_} = $_;
	}
	close(INFO);
}
