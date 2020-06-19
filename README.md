Step1:
Make new folders for each ancestry.

mkdir european/

mkdir african/

mkdir east_asian/

mkdir south_asian/

mkdir hispanic/

Step2:
Copy all of the scripts and input files into the 5 folders (european + african + east_asian + south_asian + hispanic).
Please see "List_of_input_files_and_scripts.txt" to make sure you have all the appropriate files in each folder.
Please see "Download_instructions.txt" to see where the input files were obtained from.

Step3:
Replace the step1.pl with the file appropriate for that ancestry. The default is suropean, so nothingh needs to be done to the scripts within the european folder.
#African ###
cd african/
cp step1_african.pl step1.pl
cp run_hypergeometric_ratio_tests_african.sh run_hypergeometric_ratio_tests.sh

#East Asian ###
cd east_asian/
cp step1_east_asian.pl step1.pl
cp run_hypergeometric_ratio_tests_east_asian.sh run_hypergeometric_ratio_tests.sh

#South Asian ###
cd south_asian/
cp step1_south_asian.pl step1.pl
cp run_hypergeometric_ratio_tests_south_asian.sh run_hypergeometric_ratio_tests.sh

#Hispanic ###
cd hispanic/
cp step1_hispanic.pl step1.pl
cp run_hypergeometric_ratio_tests_hispanic.sh run_hypergeometric_ratio_tests.sh

Step 4: Run the following commands within each ancestry folder. (The following commands should be run within the european folder, african folder, east asian folder, south_asian folder and hispanic folder)

##### ANALYSIS STEPS ########################################
perl only_get_physical_ppi_interactions.pl

./run_QC.sh

perl STEP1_replacement_script.pl

perl make_ppi_string_counts.pl

perl count_no_gwas_loci.pl

perl make_hypergeometric_ratio_test_input_file.pl

split -l 20000 HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies.txt HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies_

perl adjust_line_number_HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE.pl

## check the line numbers match
#wc HYPERGEOMETRIC_RATIO_TEST_INPUT_FILE_for_all_studies*adjust*

./run_hypergeometric_ratio_tests.sh

cat dhyper_output_[a-z][a-z]* | awk '!/^V1/' > merged_dhyper_output_all_studies.txt

#### BH correction for each study based on the numnber of PPI nodes each GWAs study hits ################

perl split_merged_file_by_accession_id.pl
perl automate_making_the_script_for_running_BH_correction.pl
chmod +x run_sort_by_p_value_after_BH_multiple_testing_corrections_study_accessions.sh
chmod +x run_BH_multiple_testing_corrections_study_accessions.sh
./run_BH_multiple_testing_corrections_study_accessions.sh
./run_sort_by_p_value_after_BH_multiple_testing_corrections_study_accessions.sh
perl get_study_accession_core_genes_that_pass_cut_off.pl

######### FINAL OUTPUT FILES ##############################################################
# GWAS Hits ####

european/GENE_LIST_for_each_DISEASE_ID.txt                      #European GWAS hits
african/GENE_LIST_for_each_DISEASE_ID.txt                       #African GWAS hits
east_asian/GENE_LIST_for_each_DISEASE_ID.txt                    #East Asian GWAS hits
south_asian/GENE_LIST_for_each_DISEASE_ID.txt                   #South Asian GWAS hits
hispanic/GENE_LIST_for_each_DISEASE_ID.txt                      #Hispanic GWAS hits

#Core Genes #####

european/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt     #European core genes
african/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt      #African core genes
east_asian/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt   #East Asian core genes
south_asian/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt  #South Asian core genes
hispanic/STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION.txt     #Hispanic Core genes

### MERGE GWAS HITS ACROSS ANCESTRIES TO CREATE SUPPLEMENTARY FILE 1 ########################
cp merge_GENE_LIST_for_each_DISEASE_ID_from_5_different_ancestries.pl ../
perl merge_GENE_LIST_for_each_DISEASE_ID_from_5_different_ancestries.pl

### MERGE CORE GENES ACROSS ANCESTRIES TO MERGE SUPPLEMENTARY FILE X#########################
cp merge_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION_from_5_different_ancestries.pl ../
perl merge_STUDY_ACCESSION_CORE_GENES_AFTER_BH_CORRECTION_from_5_different_ancestries.pl

# please note there will be more PPI-GWAS from running these scripts than within the supplemnatry file that is because
## additional filtering was done on the ppi-gwas to remove ppi-gwas that are within 1mB OF CORE GENE etc please see manuscript methods ###

