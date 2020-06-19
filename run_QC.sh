#!/bin/bash

perl get_snp_platform_for_each_publication.pl

perl choose_snp_platform.pl

perl step1.pl

perl step1_R_friendly.pl

perl collate_summarise_and_add_extra_columns_to_the_table_BEFORE_QC.pl

perl step2.pl

perl step3.pl

perl step4.pl

perl step5.pl

perl step5_R_friendly.pl

perl collate_summarise_and_add_extra_columns_to_the_table_AFTER_FIRST_ROUND_OF_FILTERING.pl

perl step6.pl

perl step7.pl

perl step8.pl

