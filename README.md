This code is for the paper: https://doi.org/10.1371/journal.pgen.1008903

### THE NETWORK USED IN THIS ANALYSIS IS THE FILE : network.tar.gz

### List of all 11,049 proteins used in this study : FINAL_LIST_PROTEIN_CODING_GENE_HGNC_IDS_SCORE_GT_700_ONLY_BINDING.txt

# DOWNLOAD INPUT FILES

1. Download files from the STRING network.
Navigate to https://string-db.org/, click "Download", specify "Homo sapiens" in the box that states "choose an organism"

      - Download the following files from "INTERACTION DATA"

         - 9606.protein.actions.v10.5.txt
         - 9606.protein.links.v10.5.txt

      - Download the protein aliases file from "ACCESSORY DATA"

          - protein.aliases.v10.5.txt

2. Download data from the GWAS catalog
Navigate to https://www.ebi.ac.uk/gwas/, click "Download", click "Files".

     - Download "All ancestry data v1.0"

         - gwas_catalog-ancestry_r2018-08-28.tsv

     - Download "All associations v1.0"

         - gwas_catalog_v1.0.2-associations_e93_r2018-08-28.tsv

     - Navigate to "GWAS to EFO mappings", then click on "our FTP server" and download
 
         - gwas-efo-trait-mappings.tsv

3. Download HGNC protein names
     
     - Navigate to https://www.genenames.org/, click "Downloads", then click "Statistics and download files". Download txt file of protein coding genes.

         - gene_with_protein_product.txt


# INITIAL SET UP


**Step1:** Make new folders for each ancestry

`mkdir european/`

`mkdir african/`

`mkdir east_asian/`

`mkdir south_asian/`

`mkdir hispanic/`

**Step2:** Download all scripts and files from git hub and copy into the 5 folders (european + african + east_asian + south_asian + hispanic). Please see `List_of_input_files_and_scripts.txt` to make sure you have all the appropriate files in each folder.

**Step3:** Copy certain scripts from the european folder to the folder above

`cd european/`

`cp merge_GENE_LIST_for_each_DISEASE_ID_from_5_different_ancestries.pl ../`

`cp merge_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION_from_5_different_ancestries.pl ../`

`cp get_distance.pl ../`

`cp calculate_distance_bw_them.pl ../`

`cp get_core_gene_gwas_pairs_within_1Mb.pl ../`

`cp get_all_combinations_of_two.pl ../`

`cp get_proportion_of_GWAS_hits_in_each_core_gene_detection_line.pl ../`

`cp make_S1_table.pl ../`

`cp make_S2_table.pl ../`

**Step4:** Navigate to each ancestry folder and replace the step1.pl script with the ancestry specific script. The default scripts are european, so nothing needs to be done to the scripts within the european folder.

## African 
`cd african/`

`cp step1_african.pl step1.pl`

`cp run_hypergeometric_ratio_tests_african.sh run_hypergeometric_ratio_tests.sh`

## East Asian 
`cd east_asian/`

`cp step1_east_asian.pl step1.pl`

`cp run_hypergeometric_ratio_tests_east_asian.sh run_hypergeometric_ratio_tests.sh`. 

## South Asian 
`cd south_asian/`

`cp step1_south_asian.pl step1.pl` 

`cp run_hypergeometric_ratio_tests_south_asian.sh run_hypergeometric_ratio_tests.sh` 

## Hispanic 
`cd hispanic/`

`cp step1_hispanic.pl step1.pl` 

`cp run_hypergeometric_ratio_tests_hispanic.sh run_hypergeometric_ratio_tests.sh` 


# ANALYSIS STEPS

The core gene detection is done separately for each ancestry. This means that the following commands need to be run within each ancestry folder.
(This means that the following commands should be run within the european folder, african folder, east asian folder, south_asian folder and hispanic folder)

`perl only_get_physical_ppi_interactions.pl`

`./run_QC.sh`

`perl STEP1_replacement_script.pl`

`perl make_ppi_string_counts.pl`

`perl count_no_gwas_loci.pl`

`perl make_hypergeometric_ratio_test_input_file.pl`

`split -l 20000 HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies.txt HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_`

`perl adjust_line_number_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE.pl`

check the line numbers match (wc HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies*adjust*)

`./run_hypergeometric_ratio_tests.sh`

`cat dhyper_output_[a-z][a-z]* | awk '!/^V1/' > merged_dhyper_output_all_studies.txt`

## BH correction for each study based on the number of PPI nodes that interact with GWAS hits

`perl split_merged_file_by_accession_id.pl`

`perl automate_making_the_script_for_running_BH_correction.pl` 

`chmod +x run_sort_by_p_value_after_BH_multiple_testing_corrections_study_accessions.sh`

`chmod +x run_BH_multiple_testing_corrections_study_accessions.sh`

`./run_BH_multiple_testing_corrections_study_accessions.sh`

`./run_sort_by_p_value_after_BH_multiple_testing_corrections_study_accessions.sh`

`perl get_study_accession_core_genes_that_pass_cut_off.pl`


# OUTPUT FILES     
 

### European GWAS hits:
european/GENE_LIST_for_each_DISEASE_ID.txt                  

### African GWAS hits:
african/GENE_LIST_for_each_DISEASE_ID.txt                    

### East Asian GWAS hits:
east_asian/GENE_LIST_for_each_DISEASE_ID.txt                    

### South Asian GWAS hits:
south_asian/GENE_LIST_for_each_DISEASE_ID.txt                  

### Hispanic GWAS hits:
hispanic/GENE_LIST_for_each_DISEASE_ID.txt 


### European core genes:

european/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt     

### African core genes:

african/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt    

### East Asian core genes:

east_asian/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt  

### South Asian core genes:

south_asian/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt  

### Hispanic core genes:

hispanic/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt     

### MERGE GWAS HITS ACROSS ANCESTRIES TO CREATE SUPPLEMENTARY FILE 1 

`cp merge_GENE_LIST_for_each_DISEASE_ID_from_5_different_ancestries.pl ../`

`perl merge_GENE_LIST_for_each_DISEASE_ID_from_5_different_ancestries.pl`

### MERGE CORE GENES ACROSS ANCESTRIES TO MERGE SUPPLEMENTARY FILE 

`cp merge_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION_from_5_different_ancestries.pl ../`

`perl merge_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION_from_5_different_ancestries.pl`

### FILTER CORE GENES DETECTED BY ONLY 1 GWAS hit 
`cd european/`

`perl remove_lines_with_1_overlap.pl`


`cd african/`

`perl remove_lines_with_1_overlap.pl`


`cd south_asian/`

`perl remove_lines_with_1_overlap.pl`


`cd east_asian/`

`perl remove_lines_with_1_overlap.pl`


`cd hispanic/`

`perl remove_lines_with_1_overlap.pl`

`cat european/HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt > MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt`

`cat hispanic/HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt >> MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt`

`cat african/HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt >> MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt`

`cat south_asian/HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt >> MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt`

`cat east_asian/HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt >> MERGED_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_remove_lines_with_1_overlap.txt`

`perl filter_for_2_or_more_gwas_hits.pl`

`perl annotate_studies_with_excess_PPI_edges.pl`

### Remove core genes that are within 1MB of a GWAS hit

`perl get_distance.pl`

`perl calculate_distance_bw_them.pl`

`perl get_core_gene_gwas_pairs_within_1Mb.pl`

`perl get_all_combinations_of_two.pl`

`perl get_proportion_of_GWAS_hits_in_each_core_gene_detection_line.pl`

### Make Supplementary Table 2 

`perl make_S2_table.pl`

### Make Supplementary Table 3 

`perl make_S3_table.pl`
