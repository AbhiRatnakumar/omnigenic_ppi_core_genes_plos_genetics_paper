#!/bin/bash

Rscript do_dhyper.R 20001 HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_aa_line_count_adjusted.txt dhyper_output_aa.txt
Rscript do_dhyper.R 20001 HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_ab_line_count_adjusted.txt dhyper_output_ab.txt
Rscript do_dhyper.R 10405 HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_ac_line_count_adjusted.txt dhyper_output_ac.txt
